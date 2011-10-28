# -*- encoding : utf-8 -*-
require 'spec_helper'

describe SurveyController do

  include Devise::TestHelpers

  describe "GET 'new'" do
    it "should be successful" do
      get 'new'
      response.should be_success
    end

    it "should not show the Survey if the user is logged in" do
      user = Factory :user
      sign_in user
      get 'new'
      response.should redirect_to root_path
    end

    it "should instantiate @presenter" do
      question = FactoryGirl.create(:question)
      SurveyQuestions.should_receive(:new).with([question])
      get 'new'
    end

    it "should show the Survey if the user is not logged in" do
      get 'new'
      response.should_not redirect_to root_path
    end
  end

  describe "POST 'create'" do
    it "should assign profile_points in the session" do
      ProfileBuilder.stub(:profiles_given_questions).and_return("foo")
      profile_points = ProfileBuilder.stub(:build_profiles_points).and_return("bar").call
      post 'create', :questions => {:foo => :bar}
      session[:profile_points].should == profile_points
    end

    it "should redirect to survey_path if params[:questions] is nil" do
      post 'create'
      response.should redirect_to new_survey_path
    end
  end
end
