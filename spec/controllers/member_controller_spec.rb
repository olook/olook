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
    
    describe 'should render the accept invitation page' do
      it "when receiving a valid token" do
        member = FactoryGirl.create(:member)
        get :accept_invitation, :invite_token => member.invite_token
        response.should render_template('accept_invitation')
      end
    end
  end

end
