require 'spec_helper'

describe OmniauthCallbacksController do

  before :each do
    request.env['devise.mapping'] = Devise.mappings[:user]
  end

  describe "without a logged user" do
    describe "GET facebook" do
      before :each do
        controller.stub!(:current_user).and_return(nil)
      end
      it "should redirect to welcome page" do
        User.stub(:find_for_facebook_oauth).and_return(user = mock_model(User))
        user.stub(:authenticatable_salt)
        get :facebook
        response.should redirect_to(welcome_path)
      end

      it "should redirect to welcome page" do
        User.stub(:find_for_facebook_oauth).and_return(nil)
        get :facebook
        response.should redirect_to(new_user_registration_path)
      end
    end
  end

  describe "with a logged user" do
    describe "GET facebook" do
      before :each do
        controller.stub!(:current_user).and_return(@user = mock_model(User))
      end
      it "should redirect to root path" do
        @user.should_receive(:update_attributes).with(:uid => "123", :facebook_token => "token")
        controller.env["omniauth.auth"] = {"extra" => {"user_hash" => {"id" => "123"}}, "credentials" => {"token" => "token"}}
        get :facebook
        response.should redirect_to(root_path)
      end
    end
  end
end
