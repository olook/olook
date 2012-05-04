# -*- encoding : utf-8 -*-
require 'spec_helper'

describe MembersController do
  let(:user) { FactoryGirl.create :user }
  let(:recent_user) { FactoryGirl.create :recent_user }
  let(:order) { FactoryGirl.create(:order, :user => user) }
  let(:variant) { FactoryGirl.create(:basic_shoe_size_35) }

  before :each do
    request.env['devise.mapping'] = Devise.mappings[:user]
    sign_in user
  end

  describe "GET welcome" do
    context "when user is an old one (created 1 day ago)" do
      let(:user) { FactoryGirl.create :user, :created_at => (Time.now - 1.day), :authentication_token => "RandomToken" }

      it "redirect to members' showroom page" do
        get :welcome
        response.should redirect_to(member_showroom_path)
      end

      context "login using auth token" do

        it "should login the user and set the token to nil" do
          get :welcome, :auth_token => 'RandomToken'
          User.find(user.id).authentication_token.should == nil

        end
      end
    end

    context "when user is a new one (created today)" do
      let!(:user) { FactoryGirl.create :user, :created_at => Time.now }

      it "assigns and array to products" do
        get :welcome
        assigns(:products).should == []
      end

      it "assigns user object to found user" do
        get :welcome
        assigns(:user).should eq(user)
      end

      it "should assign @facebook_app_id" do
        get :welcome
        assigns(:facebook_app_id).should eq(FACEBOOK_CONFIG["app_id"])
      end

      context "and user visit is first" do
        it "assigns true to is_the_first_visit" do
          get :welcome
          assigns(:is_the_first_visit).should == true
        end
      end

    end

  end

  describe "#showroom" do
    before :each do
      FacebookAdapter.any_instance.stub(:facebook_friends_registered_at_olook)
    end

    it "should show the member showroom page" do
      get :showroom
      response.should render_template("showroom")
      assigns(:user).should eq(user)
    end

    it "should check session and add to cart" do
      session[:order] = order.id
      session[:offline_variant] = { "id" => variant.id }
      session[:offline_first_access] = true
      get :showroom
      order.line_items.count.should  be_eql(1)
      session[:offline_first_access].should be_nil
      session[:offline_variant].should be_nil
    end

    it "should assign @lookbooks" do
      get :showroom
      assigns(:lookbooks).should eq(Lookbook.where("active = 1").order("created_at DESC"))
    end

    it "should assign @friends" do
      FacebookAdapter.any_instance.should_receive(:facebook_friends_registered_at_olook).and_return([:fake_friend])
      get :showroom
      assigns(:friends).should == [:fake_friend]
    end

    it "should redirect to facebook_connect_path if the user has a invalid token" do
      FacebookAdapter.any_instance.should_receive(:facebook_friends_registered_at_olook).and_raise(Koala::Facebook::APIError)
      get :showroom
      response.should redirect_to(facebook_connect_path)
    end

    it "should not redirect to facebook_connect_path if the user has a valid token" do
      get :showroom
      response.should_not redirect_to(facebook_connect_path)
    end
   
  end

  it "#invite_by_email" do
    emails = ['jane@friend.com', 'invalid email', 'mary@friend.com', 'lily@friend.com', 'rose@friend.com']
    joined_emails = "#{emails[0]},#{emails[1]}\r#{emails[2]}\t#{emails[3]};#{emails[4]}"

    mock_invites = emails.map do |email|
      invite = double(Invite)
      invite
    end
    member = double(User)
    member.should_receive(:invites_for).with(emails).and_return(mock_invites)
    member.should_receive(:add_event).with(EventType::SEND_INVITE, '5 invites sent')
    member.stub(:has_early_access?).and_return(true)
    member.stub(:half_user).and_return(false)
    subject.stub(:current_user) { member }
    
    post :invite_by_email, :invite_mail_list => joined_emails

    response.should redirect_to(member_invite_path)
    flash[:notice].should match /\d+ convites enviados com sucesso!/
  end

  describe "#import_contacts" do
    before :each do
      @email_provider = 'yahoo'
      @oauth_token = "xYxYYxx"
      @oauth_secret = "xYxYYxx"
      @oauth_verifier = "xYxYYxx"
      session['yahoo_request_secret'] = "xYxYYxx"

      @adapter = double
      @adapter.stub(:contacts).and_return(@contacts = double)
    end

    it "should assign @contacts" do
      ContactsAdapter.stub(:new).with(nil, nil, @oauth_token, @oauth_secret, @oauth_verifier).and_return(@adapter)
      get :import_contacts, :oauth_token => @oauth_token, :oauth_verifier => @oauth_verifier
      assigns(:contacts).should eq(@contacts)
    end

    it "should call contacts from contacts adapter" do
      ContactsAdapter.should_receive(:new).with(nil, nil, @oauth_token, @oauth_secret, @oauth_verifier).and_return(@adapter)
      get :import_contacts, :oauth_token => @oauth_token, :oauth_verifier => @oauth_verifier
      response.should render_template("import_contacts")
    end
  end

  describe "#show_imported_contacts" do
    before :each do
      @email_provider = 'gmail'
      @login = "john@doe.com"
      @password = "foobar"

      @adapter = double
      @adapter.stub(:contacts).and_return(@contacts = double)
    end

    it "should assign @contacts" do
      ContactsAdapter.stub(:new).with(@login, @password).and_return(@adapter)
      post :show_imported_contacts, :email_provider => @email_provider, :login => @login, :password => @password
      assigns(:contacts).should eq(@contacts)
    end

    it "should call contacts from contacts adapter" do
      ContactsAdapter.should_receive(:new).with(@login, @password).and_return(@adapter)
      post :show_imported_contacts, :email_provider => @email_provider, :login => @login, :password => @password
      response.should render_template("show_imported_contacts")
    end
  end

  describe "#invite_imported_contacts" do
    it "should invite users by email" do
      emails = ['jane@friend.com', 'invalid email', 'mary@friend.com']
      mock_invites = emails.map do |email|
        invite = double(Invite)
        invite
      end
      member = double(User)
      member.should_receive(:invites_for).with(emails).and_return(mock_invites)
      member.should_receive(:add_event).with(EventType::SEND_IMPORTED_CONTACTS, '3 invites from imported contacts sent')
      member.stub(:has_early_access?).and_return(true)
      member.stub(:half_user).and_return(false)
      subject.stub(:current_user) { member }

      post :invite_imported_contacts, :email_provider => "gmail", :email_address => emails

      response.should redirect_to(member_invite_path)
      flash[:notice].should == "3 Convites enviados com sucesso!"
    end
  end

  describe "first visit" do
    use_vcr_cassette('yahoo', :match_requests_on => [:host, :path])

    before :each do
      user.events.where(:event_type => EventType::FIRST_VISIT).destroy_all
      FacebookAdapter.any_instance.stub(:facebook_friends_registered_at_olook)
    end

    it "should assign true for @is_the_first_visit" do
      get :showroom
      assigns(:is_the_first_visit).should eq(true)
    end

    it "should not assign true for @is_the_first_visit" do
      user.record_first_visit
      get :showroom
      assigns(:is_the_first_visit).should_not eq(true)
    end
  end

  describe "#invite_list" do
    before :each do
      (1..20).each do |i|
        FactoryGirl.create(:invite, :user => user, :email => "a#{i}@test.com")
      end
    end

    it "should return all invites the user sent, paginated with 15 per page" do
      get :invite_list
      response.should render_template("invite_list")
      assigns(:user).should == user
      assigns(:invites).all.should == user.invites[0..14]
    end
  end

end
