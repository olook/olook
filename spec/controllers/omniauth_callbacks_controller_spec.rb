require 'spec_helper'

describe OmniauthCallbacksController do

  before :each do
    request.env['devise.mapping'] = Devise.mappings[:user]
  end

  describe "GET facebook" do
    it "should redirect if the user dont fill the Survey" do
      session[:profile_points] = nil
      User.stub(:find_for_facebook_oauth).and_return(["", true])
      get :facebook
      response.should redirect_to(survey_index_path)
    end

    it "should not redirect when the user fill the Survey" do
      session[:profile_points] = :some_data
      User.stub(:find_for_facebook_oauth).and_return(@user, new_user = mock_model(User), false)
      @user.stub(:persisted?).and_return(false)
      get :facebook
      response.should_not redirect_to(survey_index_path)
    end
  end
   
end