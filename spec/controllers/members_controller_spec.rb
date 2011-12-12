# -*- encoding : utf-8 -*-
require 'spec_helper'

describe MembersController do
  let(:user) { FactoryGirl.create :user }

  before :each do
    request.env['devise.mapping'] = Devise.mappings[:user]
    sign_in user
  end

  describe "#invite" do
    use_vcr_cassette('yahoo', :match_requests_on => [:host, :path])

    it "should show the member invite page" do
      get :invite
      response.should render_template("invite")
      assigns(:member).should eq(user)
    end

    it "should assign @facebook_app_id" do
      get :invite
      assigns(:facebook_app_id).should eq(FACEBOOK_CONFIG["app_id"])
    end
  end

  describe "#how_to" do
    it "should show the member how_to page" do
      get :how_to
      response.should render_template("how_to")
      assigns(:member).should eq(user)
    end
  end

  describe "#showroom" do
    it "should show the member showroom page" do
      get :showroom
      response.should render_template("showroom")
      assigns(:member).should eq(user)
    end
  end

  describe "#accept_invitation should redirect to root" do
    describe "and show error message" do
      it "when receiving a blank token" do
        get :accept_invitation, :invite_token => ''
        response.should redirect_to(root_path, :alert =>'Convite inválido')
      end
      it "when receiving a token with invalid format" do
        get :accept_invitation, :invite_token => 'xx'
        response.should redirect_to(root_path, :alert =>'Convite inválido')
      end
      it "when receiving a token that doesn't exist" do
        get :accept_invitation, :invite_token => 'x'*20
        response.should redirect_to(root_path, :alert =>'Convite inválido')
      end
    end

    describe 'with the inviting member information in the session' do
      let(:inviting_member) { FactoryGirl.create(:member) }

      it "when receiving a valid token" do
        get :accept_invitation, :invite_token => inviting_member.invite_token
        response.should redirect_to(root_path)
        session[:invite].should == {:invite_token => inviting_member.invite_token,
                                    :invited_by => inviting_member.name}
      end

      describe "when passing query string parameters" do
        it "redirects and pass a generic param" do
          get :accept_invitation, :invite_token => inviting_member.invite_token, :utm_source => 'olook'
          response.location.should match(/\?.*utm_source=olook/)
        end

        it "redirects and does not pass invite_token" do
          get :accept_invitation, :invite_token => inviting_member.invite_token
          response.location.should_not match(/\?.*invite_token=w#{inviting_member.invite_token}/)
        end
      end

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
    end

    it "should record first visit for member user" do
      get :invite
      user.events.where(:event_type => EventType::FIRST_VISIT).should_not be_empty
    end

    it "should assign true for @is_the_first_visit" do
      get :invite
      assigns(:is_the_first_visit).should eq(true)
    end

    it "should not assign true for @is_the_first_visit" do
      user.record_first_visit
      get :invite
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
      assigns(:member).should == user
      assigns(:invites).all.should == user.invites[0..14]
    end
  end

end
