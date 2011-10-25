# -*- encoding : utf-8 -*-
require 'spec_helper'

describe RegistrationsController do

  let(:user_attributes) { {:email => "mail@mail.com", :password => "123456", :password_confirmation => "123456", :first_name => "User Name", :last_name => "Last Name" } }

  let(:birthday) { {:day => "27", :month => "9", :year => "1987"} }

  before :each do
    request.env['devise.mapping'] = Devise.mappings[:user]
  end

  describe "GET new" do
    it "should redirect if the user dont fill the Survey" do
      session[:profile_points] = nil
      get :new
      response.should redirect_to(new_survey_path)
    end

    it "should not redirect when the user fill the Survey" do
      session[:profile_points] = :some_data
      get :new
      response.should_not redirect_to(new_survey_path)
    end

    it "should not build the resource using session data" do
      session[:profile_points] = :some_data
      get :new
      controller.resource.email.should eq(nil)
    end

    it "should build the resource using session data" do
      session[:profile_points] = :some_data
      data = {"email" => "mail@mail.com"}
      controller.stub(:user_data_from_session).and_return(data)
      get :new
      controller.resource.email.should eq("mail@mail.com")
    end
  end

  describe "POST create with profile_points" do
    it "should create user points" do
      session[:questions] = {:foo => :bar}
      session[:birthday] = birthday
      session[:profile_points] = {1 => 2, 3 => 4}
      expect {
          post :create, :user => user_attributes
        }.to change(Point, :count).by(session[:profile_points].size)
    end
  end

  describe "POST create without profile_points" do

    before :each do
      session[:questions] = {:foo => :bar}
      session[:birthday] = birthday
      ProfileBuilder.any_instance.stub(:create_user_points)
    end

    it "should create a User" do
     session[:profile_points] = :some_data
     expect {
          post :create, :user => user_attributes
        }.to change(User, :count).by(1)
    end

    it "should assigns user birthday" do
     session[:profile_points] = :some_data
     session[:birthday] = birthday
     post :create, :user => user_attributes
     user = User.find_by_email(user_attributes[:email])
     user.birthday.to_s.should == "1987-09-27"
    end

    it "should redirect to welcome page" do
      session[:profile_points] = :some_data
      post :create, :user => user_attributes
      response.should redirect_to(welcome_path)
    end

    it "should not redirect to welcome page" do
      session[:profile_points] = :some_data
      resource = double
      resource.stub(:save).and_return(false)
      controller.stub(:set_resource_attributes)
      controller.stub(:resource).and_return(resource)
      post :create, :user => user_attributes
      response.should_not redirect_to(welcome_path)
    end

    it "should not redirect to welcome page" do
      session[:profile_points] = :some_data
      resource = double
      resource.stub(:save).and_return(true)
      resource.stub(:active_for_authentication?).and_return(false)
      controller.stub(:set_resource_attributes)
      controller.stub(:resource).and_return(resource)
      controller.stub(:inactive_reason)
      post :create, :user => user_attributes
      response.should_not redirect_to(welcome_path)
    end

    it "should redirect if the user dont fill the Survey" do
      session[:profile_points] = nil
      post :create
      response.should redirect_to(new_survey_path)
    end

    it "should not redirect when the user fill the Survey" do
      session[:profile_points] = :some_data
      post :create
      response.should_not redirect_to(new_survey_path)
    end

    it "should create a SurveyAnswers" do
     session[:profile_points] = :some_data
     expect {
          post :create, :user => user_attributes
        }.to change(SurveyAnswer, :count).by(1)
    end

    it "should create a SurveyAnswers with questions and birthday" do
     session[:profile_points] = :some_data
     post :create, :user => user_attributes
     SurveyAnswer.last.answers.should eq({:foo=>:bar}.merge(birthday))
    end

    it "should clean the sessions" do
     session[:profile_points] = :some_data
     session[:invite] = {:intive_token => Devise.friendly_token}
     session["devise.facebook_data"] = {"extra" => {"user_hash" => "xyz"}, "credentials" => {"token" => "abc"}}
     User.any_instance.stub(:accept_invitation_with_token)
     User.stub(:new_with_session).and_return(Factory.build(:user, :cpf => "11144477735"))
     post :create, :user => user_attributes.merge!({:cpf => "11144477735"})
     [:profile_points, :questions, :invite, "devise.facebook_data"].each {|key| session[key].should == nil}
    end
  end
end
