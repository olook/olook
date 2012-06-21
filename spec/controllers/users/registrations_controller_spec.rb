# -*- encoding : utf-8 -*-
require 'spec_helper'

describe Users::RegistrationsController do

  let(:user_attributes) { {"email" => "mail@mail.com", "password" => "123456", "password_confirmation" => "123456", "first_name" => "User Name", "last_name" => "Last Name" } }
  let(:user_attributes_invalid) { {"email" => "mail@mail.com", "password" => "12345", "password_confirmation" => "123456", "first_name" => "User Name", "last_name" => "Last Name" } }

  let(:birthday) { {:day => "27", :month => "9", :year => "1987"} }
  let(:facebook_data) { {"extra" => {"raw_info" => "xyz"}, "credentials" => {"token" => "abc"}} }

  render_views

  before :all do
    ActiveRecord::Base.observers.disable :all
  end
  
  after :all do
    ActiveRecord::Base.observers.enable :all
  end

  before :each do
    request.env['devise.mapping'] = Devise.mappings[:user]
  end

  after :each do
    session[:profile_questions] = nil
    session[:profile_birthday] = nil
  end


  describe "registration form" do
    context "when is full user" do
      it "should redirect if the user dont fill the Survey" do
        session[:profile_questions] = nil
        session[:profile_birthday] = :some_data
        get :new
        response.should redirect_to(new_survey_path)
      end

      it "should redirect if the user dont fill the birthday" do
        session[:profile_questions] = :some_data
        session[:profile_birthday] = nil
        get :new
        response.should redirect_to(new_survey_path)
      end

      xit "should render new when user fill the Survey" do
        session[:profile_questions] = :some_data
        session[:profile_birthday] = :some_data
        get :new
        response.should render_template ["layouts/site", "new"]
      end

      xit "should not build the resource using session data" do
        session[:profile_questions] = :some_data
        get :new
        controller.resource.email.should eq(nil)
      end

      xit "should assigns @signup_with_facebook" do
        session[:profile_questions] = :some_data
        session["devise.facebook_data"] = facebook_data
        get :new
        assigns(:signup_with_facebook).should eq(true)
      end

      xit "should build the resource using session data" do
        session[:profile_questions] = :some_data
        data = {"email" => "mail@mail.com"}
        controller.stub(:user_data_from_session).and_return(data)
        get :new
        controller.resource.email.should eq("mail@mail.com")
      end
    end
    
    context "when is half user" do
      it "should render new_half" do
        get :new_half
        response.should render_template ["layouts/site", "new_half"]
      end

      xit "should not build the resource using session data" do
        session[:profile_questions] = nil
        get :new_half
        controller.resource.email.should eq(nil)
      end

      xit "should assigns @signup_with_facebook" do
        session[:profile_questions] = :some_data
        session["devise.facebook_data"] = facebook_data
        get :new_half
        assigns(:signup_with_facebook).should eq(true)
      end

      xit "should build the resource using session data" do
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
    it "should clear tracking session"
    it "should save invite"
    it "should clear invite session"
    it "should save facebook"
    it "should clear facebook session"
    
    context "when is full user" do
      it "should redirect if the user dont fill the Survey" do
        session[:profile_questions] = nil
        session[:profile_birthday] = :some_data
        post :create, :user => user_attributes
        response.should redirect_to(new_survey_path)
      end

      it "should redirect if the user dont fill the birthday" do
        session[:profile_questions] = :some_data
        session[:profile_birthday] = nil
        post :create, :user => user_attributes
        response.should redirect_to(new_survey_path)
      end

      xit "should save user" do
        session[:profile_questions] = :some_data
        session[:profile_birthday] = :some_data
        expect {
          post :create, :user => user_attributes
        }.to change(User, :count).by(1)
      end
      
      xit "should response error when invalid attributes" do
        session[:profile_questions] = :some_data
        session[:profile_birthday] = :some_data
        expect {
          post :create, :user => user_attributes_invalid
          response.should render_template ["layouts/site", "new"]
        }.to_not change(User, :count)
      end

      it "should save birthday"
      it "should clear birthday session"
      it "should save questions"
      it "should clear questions in session"
      it "should redirect to welcome"
    end
    
    context "when is half user" do
      context "with gift product in session" do
        xit "should save user" do
          expect {
            post :create_half, :user => user_attributes
          }.to change(User, :count).by(1)
        end
        
        it "should response error when invalid attributes" do
          expect {
            post :create_half, :user => user_attributes_invalid
            response.should render_template ["layouts/site", "new_half"]
          }.to_not change(User, :count)
        end
        
        it "should invoke CartBuilder to add Products"
        it "should redirect to cart page"
      end

      context "with has offline product in session" do
        xit "should save user" do
          expect {
            post :create_half, :user => user_attributes
          }.to change(User, :count).by(1)
        end
        
        it "should response error when invalid attributes" do
          expect {
            post :create_half, :user => user_attributes_invalid
            response.should render_template ["layouts/site", "new_half"]
          }.to_not change(User, :count)
        end
        
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
      response.should render_template ["layouts/my_account", "edit"]
    end

    it "should not update the cpf" do
      put :update, :id => @user.id, :user => user_attributes.merge("cpf" => "19762003691")
      @user.reload.cpf.should be_nil
      response.should render_template ["layouts/my_account", "edit"]
    end

    it "should render the edit template" do
      User.any_instance.stub(:update_attributes).and_return(false)
      put :update, :id => @user.id, :user => user_attributes
      response.should render_template ["layouts/my_account", "edit"]
    end
  end

end
