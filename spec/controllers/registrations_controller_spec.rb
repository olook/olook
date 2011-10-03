require 'spec_helper'

describe RegistrationsController do

  let(:user_attributes) { {:email => "mail@mail.com", :password => "123456", :password_confirmation => "123456", :name => "User" } }

  before :each do
    request.env['devise.mapping'] = Devise.mappings[:user]
  end

  describe "GET new" do
    it "should redirect if the user dont fill the Survey" do
      session[:profile_points] = nil
      get :new
      response.should redirect_to(survey_index_path)
    end

    it "should not redirect when the user fill the Survey" do
      session[:profile_points] = :some_data
      get :new
      response.should_not redirect_to(survey_index_path)
    end
  end

  describe "POST create " do

    before :each do
      User.any_instance.stub(:counts_and_write_points)
    end

    it "should create a User" do
     session[:profile_points] = :some_data
     expect {
          post :create, :user => user_attributes
        }.to change(User, :count).by(1)    
    end

    it "should redirect if the user dont fill the Survey" do
      session[:profile_points] = nil
      post :create
      response.should redirect_to(survey_index_path)
    end

    it "should not redirect when the user fill the Survey" do
      session[:profile_points] = :some_data
      post :create
      response.should_not redirect_to(survey_index_path)
    end

    it "should create a SurveyAnswers" do
      session[:profile_points] = :some_data
      expect {
        post :create, :user => user_attributes
      }.to change(SurveyAnswer, :count).by(1)    
    end

    it "should accept the invitation when provided" do
      subject.stub(:check_survey_response).and_return(true)
      session[:invite] = { :invitation_token => :mock_token }
      User.any_instance.should_receive(:accept_invitation_with_token).with(:mock_token)
      post :create, :user => user_attributes
    end
  end
end
