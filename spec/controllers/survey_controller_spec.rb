require 'spec_helper'

describe SurveyController do

  describe "GET 'index'" do
    it "should be successful" do
      get 'index'
      response.should be_success
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
