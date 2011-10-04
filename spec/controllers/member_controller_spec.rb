# -*- encoding : utf-8 -*-
require 'spec_helper'

describe MemberController do
  describe "#invite" do
    it "should show the member invite page" do
      subject.stub(:current_user) { :user }
      get :invite
      response.should render_template("invite")
      assigns(:member).should eq(:user)
    end
  end

  describe "#accept_invitation" do
    describe "should redirect to root" do
      it "when receiving a blank token" do
        get :accept_invitation, :invite_token => ''
        response.should redirect_to(root_path)
        flash[:alert].should == 'Invalid token'
      end
      it "when receiving a token with invalid format" do
        get :accept_invitation, :invite_token => 'xx'
        response.should redirect_to(root_path)
        flash[:alert].should == 'Invalid token'
      end
      it "when receiving a token that doesn't exist" do
        get :accept_invitation, :invite_token => 'x'*20
        response.should redirect_to(root_path)
        flash[:alert].should == 'Invalid token'
      end
    end

    describe 'should redirect visitor to signup page with invite information' do
      it "when receiving a valid token" do
        inviting_member = FactoryGirl.create(:member)
        get :accept_invitation, :invite_token => inviting_member.invite_token
        response.should redirect_to(new_user_registration_path)
        session[:invite].should == {:invite_token => inviting_member.invite_token,
                                    :invited_by => inviting_member.first_name}
      end
    end
  end

  it "#invite_by_email" do
    emails = ['jane@friend.com', 'linda@friend.com', 'mary@friend.com']
    member = double(User)
    member.should_receive(:invite_by_email).with(emails)
    subject.stub(:current_user) { member }

    post :invite_by_email, :invite_mail_list => emails.join(', ')

    response.should redirect_to(member_invite_path)
    flash[:notice].should == "Convites enviados com sucesso!"
  end
end
