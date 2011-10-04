require 'spec_helper'

describe PagesController do

  before :each do
    request.env['devise.mapping'] = Devise.mappings[:user]
  end

  describe "GET 'welcome'" do
    context "with a logged user" do
      it "should be successful" do
        user = Factory :user
        sign_in user
        get 'welcome'
        response.should be_success
      end
    end

    context "without a logged user" do
      it "should be redirected to login" do
        get 'welcome'
        response.should redirect_to new_user_session_path
      end
    end
  end

end
