# -*- encoding : utf-8 -*-
require 'spec_helper'

describe MembersController do
  let(:user) { FactoryGirl.create :user }
  let(:recent_user) { FactoryGirl.create :recent_user }

  before :each do
    request.env['devise.mapping'] = Devise.mappings[:user]
    sign_in user
  end

  describe "GET welcome" do
    let(:user) { FactoryGirl.create :user, :authentication_token => "RandomToken" }

    it "should login the user and set the token to nil" do
      get :welcome, :auth_token => user.authentication_token
      User.find(user.id).authentication_token.should == user.authentication_token
    end
  end

  describe "#showroom" do
    before :all do
      user.add_event(EventType::FIRST_VISIT)
    end

    before :each do
      FacebookAdapter.any_instance.stub(:facebook_friends_registered_at_olook)
    end

    it "should show the member showroom page" do
      get :showroom
      response.should render_template("showroom")
      assigns(:user).should eq(user)
    end

    it "should assign @friends" do
      FacebookAdapter.any_instance.should_receive(:facebook_friends_registered_at_olook).and_return([:fake_friend])
      get :showroom
      assigns(:friends).should == [:fake_friend]
    end

    it "should redirect to facebook_connect_path if the user has a invalid token" do
      FacebookAdapter.any_instance.should_receive(:facebook_friends_registered_at_olook).and_raise(Koala::Facebook::APIError)
      get :showroom
      response.should be_ok
    end

    it "should not redirect to facebook_connect_path if the user has a valid token" do
      get :showroom
      response.should_not redirect_to(facebook_connect_path)
    end

  end

  it "#invite_by_email" do
    emails = ['jane@friend.com', 'invalid email', 'mary@friend.com', 'lily@friend.com', 'rose@friend.com']
    joined_emails = "#{emails[0]},#{emails[1]}\r#{emails[2]}\t#{emails[3]};#{emails[4]}"
    request.env["HTTP_REFERER"] = "where_i_came_from"

    mock_invites = emails.map do |email|
      invite = double(Invite)
      invite
    end
    member = User.new
    member.should_receive(:invites_for).with(emails).and_return(mock_invites)
    member.should_receive(:add_event).with(EventType::SEND_INVITE, '5 invites sent')
    member.stub(:half_user).and_return(false)
    subject.stub(:current_user) { member }

    post :invite_by_email, :invite_mail_list => joined_emails

    response.should redirect_to "where_i_came_from"
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
      member = User.new
      member.should_receive(:invites_for).with(emails).and_return(mock_invites)
      member.should_receive(:add_event).with(EventType::SEND_IMPORTED_CONTACTS, '3 invites from imported contacts sent')
      member.stub(:half_user).and_return(false)
      subject.stub(:current_user) { member }

      post :invite_imported_contacts, :email_provider => "gmail", :email_address => emails

      response.should redirect_to(member_invite_path)
      flash[:notice].should == "3 Convites enviados com sucesso!"
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

  describe "GET earn_credits" do
    it "should return 200" do
      get :earn_credits
      response.status.should eq(200)
    end
  end
end
