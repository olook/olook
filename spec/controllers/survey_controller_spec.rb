require 'spec_helper'

describe SurveyController do

  include Devise::TestHelpers

  describe "GET 'index'" do
    it "should be successful" do
      get 'index'
      response.should be_success
    end

    it "should not show the Survey if the user is logged in" do
      user = Factory :user
      sign_in user
      get 'index'
      response.should redirect_to root_path
    end

    it "should show the Survey if the user is not logged in" do
      get 'index'
      response.should_not redirect_to root_path
    end
  end

  describe "POST 'create'" do
    it "should assign profile_points in the session" do
      Profile.stub(:profiles_given_questions).and_return("foo")
      profile_points = Profile.stub(:build_profiles_points).and_return("bar").call
      post 'create'
      session[:profile_points].should == profile_points
    end
  end
end
