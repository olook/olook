# -*- encoding : utf-8 -*-
require 'spec_helper'

describe Users::RegistrationsController do

  let(:user_attributes) { {"email" => "mail@mail.com", "password" => "123456", "password_confirmation" => "123456", "first_name" => "User Name", "last_name" => "Last Name" } }

  let(:birthday) { {:day => "27", :month => "9", :year => "1987"} }
  let(:facebook_data) { {"extra" => {"raw_info" => "xyz"}, "credentials" => {"token" => "abc"}} }

  before :all do
    ActiveRecord::Base.observers.disable :all
  end
  
  after :all do
    ActiveRecord::Base.observers.enable :all
  end

  before :each do
    request.env['devise.mapping'] = Devise.mappings[:user]
  end

  describe "registration form" do
    context "when is full user" do
      after :each do
        session[:profile_questions] = nil
      end

      it "should redirect if the user dont fill the Survey" do
        get :new
        response.should redirect_to(new_survey_path)
      end

      it "should not redirect when the user fill the Survey" do
        session[:profile_questions] = :some_data
        get :new
        response.should_not redirect_to(new_survey_path)
      end

      it "should not build the resource using session data" do
        session[:profile_questions] = :some_data
        get :new
        controller.resource.email.should eq(nil)
      end

      it "should assigns @signup_with_facebook" do
        session[:profile_questions] = :some_data
        session["devise.facebook_data"] = facebook_data
        get :new
        assigns(:signup_with_facebook).should eq(true)
      end

      it "should build the resource using session data" do
        session[:profile_questions] = :some_data
        data = {"email" => "mail@mail.com"}
        controller.stub(:user_data_from_session).and_return(data)
        get :new
        controller.resource.email.should eq("mail@mail.com")
      end
    end
    
    context "when is half user" do
      it "should not redirect when the user fill the Survey" do
        session[:profile_questions] = :some_data
        get :new_half
        response.should_not redirect_to(new_survey_path)
      end

      it "should not build the resource using session data" do
        session[:profile_questions] = nil
        get :new_half
        controller.resource.email.should eq(nil)
      end

      it "should assigns @signup_with_facebook" do
        session[:profile_questions] = :some_data
        session["devise.facebook_data"] = facebook_data
        get :new_half
        assigns(:signup_with_facebook).should eq(true)
      end

      it "should build the resource using session data" do
        session[:profile_questions] = :some_data
        data = {"email" => "mail@mail.com"}
        controller.stub(:user_data_from_session).and_return(data)
        get :new_half
        controller.resource.email.should eq("mail@mail.com")
      end
    end
  end
  
  describe "sign up" do
    it "should save tracking"
    it "should save facebook"
    it "should save birthday"
    it "should save invite"
    
    context "when is full user" do
      context "with questions in session" do
        it "should save user"
        it "should save questions"
        it "should redirect to welcome"
      end
      
      context "without questions in session" do
        it "should redirect to survey" do
        end
      end
    end
    
    context "when is half user" do
      context "with gift product in session" do
        it "should save user"
        it "should invoke CartBuilder to add Products"
        it "should redirect to cart page"
      end
      context "with has offline product in session" do
        it "should save user"
        it "should invoke CartBuilder to add Products"
        it "should redirect to cart page"
      end
      it "should redirect to gift page when no has offline/gift products"
    end
  end

  describe "PUT update" do
    before :each do
      @user = FactoryGirl.create(:user)
      sign_in @user
    end

    it "should update the user" do
      User.any_instance.should_receive(:update_attributes).with(user_attributes)
      put :update, :id => @user.id, :user => user_attributes
    end

    it "should not update the cpf" do
      put :update, :id => @user.id, :user => user_attributes.merge("cpf" => "19762003691")
      @user.reload.cpf.should be_nil
    end

    it "should render the edit template" do
      User.any_instance.stub(:update_attributes).and_return(false)
      put :update, :id => @user.id, :user => user_attributes
      response.should render_template('edit')
    end
  end

end
