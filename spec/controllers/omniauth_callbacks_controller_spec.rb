require 'spec_helper'

describe OmniauthCallbacksController do

  before :each do
    request.env['devise.mapping'] = Devise.mappings[:user]
  end

  describe "GET facebook" do
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
