# -*- encoding : utf-8 -*-
require 'spec_helper'

describe RegistrationsController do

  let(:user_attributes) { {:email => "mail@mail.com", :password => "123456", :password_confirmation => "123456", :first_name => "User Name", :last_name => "Last Name" } }

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

  describe "POST create with a profile_points fake" do

    before :each do
      ProfileBuilder.any_instance.stub(:create_user_points)
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

    it "should clean the sessions" do
     session[:profile_points] = :some_data
     session[:questions] = :some_data
     session[:invite] = {:intive_token => Devise.friendly_token}
     session["devise.facebook_data"] = :some_data
     User.any_instance.stub(:accept_invitation_with_token)
     User.stub(:new_with_session).and_return(Factory.build(:user, :cpf => "11144477735"))
     post :create, :user => user_attributes.merge!({:cpf => "11144477735"})
     [:profile_points, :questions, :invite, "devise.facebook_data"].each {|key| session[key].should == nil}
    end
  end

  describe "POST create" do
    it "should create a User" do
     profile_points = :some_data
     session[:profile_points] = profile_points
     ProfileBuilder.any_instance.should_receive(:create_user_points).with(profile_points)
     post :create, :user => user_attributes
    end
  end
end
