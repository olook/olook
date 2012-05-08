require 'spec_helper'

describe User::SettingsController do
  let(:user) { FactoryGirl.create :user }

  before :each do
    request.env['devise.mapping'] = Devise.mappings[:user]
    sign_in user
  end

  describe "GET facebook" do
    it "should render the facebook settings page" do
      get :facebook
      response.should be_success
    end
  end

  describe "GET showroom" do
    let!(:question) { double(:question) }

    it "should render the showroom settings page" do
      get :showroom
      response.should be_success
    end

    it "assigs @questions with the questions from the registration survey" do
      Question.should_receive(:from_registration_survey).and_return([question])
      get :showroom
      assigns(:questions).should == [question]
    end

    it "assigns @presenter a new SurveyQuestions" do
      Question.stub(:from_registration_survey).and_return([question])
      survey_questions = double(:survey_questions)
      SurveyQuestions.should_receive(:new).with([question]).and_return(survey_questions)
      get :showroom
      assigns(:presenter).should == survey_questions
    end
  end
end
