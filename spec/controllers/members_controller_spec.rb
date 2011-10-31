# -*- encoding : utf-8 -*-
require 'spec_helper'

describe MembersController do
  let(:user) { FactoryGirl.create :user }

  before :each do
    request.env['devise.mapping'] = Devise.mappings[:user]
    sign_in user
  end

  describe "#invite" do
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

  describe "#accept_invitation" do
    describe "should redirect to root" do
      it "when receiving a blank token" do
        get :accept_invitation, :invite_token => ''
        response.should redirect_to(member_invite_path, :alert =>'Convite inválido')
      end
      it "when receiving a token with invalid format" do
        get :accept_invitation, :invite_token => 'xx'
        response.should redirect_to(member_invite_path, :alert =>'Convite inválido')
      end
      it "when receiving a token that doesn't exist" do
        get :accept_invitation, :invite_token => 'x'*20
        response.should redirect_to(member_invite_path, :alert =>'Convite inválido')
      end
    end

    describe 'should redirect visitor to signup page with invite information' do
      it "when receiving a valid token" do
        inviting_member = FactoryGirl.create(:member)
        get :accept_invitation, :invite_token => inviting_member.invite_token
        response.should redirect_to(new_user_registration_path)
        session[:invite].should == {:invite_token => inviting_member.invite_token,
                                    :invited_by => inviting_member.name}
      end
    end
  end

  it "#invite_by_email" do
    emails = ['jane@friend.com', 'invalid email', 'mary@friend.com']
    mock_invites = emails.map do |email|
      invite = double(Invite)
      invite
    end
    member = double(User)
    member.should_receive(:invites_for).with(emails).and_return(mock_invites)
    member.should_receive(:add_event).with(EventType::SEND_INVITE, '3 invites sent')
    subject.stub(:current_user) { member }
    
    post :invite_by_email, :invite_mail_list => emails.join(', ')

    response.should redirect_to(member_invite_path)
    flash[:notice].should match /\d+ convites enviados com sucesso!/
  end

  describe "#import_contacts" do
    it "should show the import contacts page" do
      get :import_contacts
      response.should render_template("import_contacts")
    end
  end

  describe "#show_imported_contacts" do
    before :each do
      @email_provider = 1
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
      subject.stub(:current_user) { member }

      post :invite_imported_contacts, :email_address => emails

      response.should redirect_to(member_import_contacts_path)
      flash[:notice].should == "Convites enviados com sucesso!"
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
