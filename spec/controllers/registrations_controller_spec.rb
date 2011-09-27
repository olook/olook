require 'spec_helper'

describe RegistrationsController do

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
  end
end