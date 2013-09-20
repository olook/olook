# -*- encoding : utf-8 -*-
require 'spec_helper'

describe SurveyController do

  include Devise::TestHelpers

  let(:user) { FactoryGirl.create(:user) }
  let(:params) { {:questions => {:foo => :bar}, :year => '2012', :month => '12', :day => '12'} }

  describe "GET 'new'" do
    it "should be successful" do
      get 'new'
      response.should be_success
    end

    it "should also show the Survey if the user is logged in" do
      user = FactoryGirl.create(:user)
      sign_in user
      get 'new'
      response.should be_success
    end

    it "gets all questions and answers from registration survey and assigns to question" do
      questions = [1,2,3]
      Question.should_receive(:from_registration_survey).and_return(questions)
      get 'new'
      assigns(:questions).should eq questions
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

  describe "answering quiz" do
    it "should redirect to survey_path when no has questions" do
      post :create
      response.should redirect_to wysquiz_path
    end

    context "without user" do
      it "should save questions to session" do
        post :create, params
        session[:profile_questions].should == {"foo" => "bar"}
        session[:profile_birthday].should == {:day => '12', :month => '12', :year => '2012'}
      end

      it "should redirect to registration" do
        post :create, params
        response.should redirect_to new_user_registration_path
      end
    end

    context "with user" do

      before :each do
        sign_in user
      end

      it "should not save questions to session" do
        ProfileBuilder.stub(:factory)
        post :create, params
        session[:profile_questions].should be_nil
        session[:profile_birthday].should be_nil
      end

      it "should upgrade to full user" do
        user.should_receive(:upgrade_to_full_user!)
        controller.stub(:current_user).and_return(user)
        ProfileBuilder.stub(:factory)
        post :create, params
      end

      it "should save questions to database" do
        ProfileBuilder.should_receive(:factory).with(
          {:day => '12', :month => '12', :year => '2012'},
          {"foo" => 'bar'},
          user
        )
        post :create, params
      end

      context "when has points in user" do
        before :each do
          ProfileBuilder.stub(:factory)
          user.points.stub(:count).and_return(1)
          controller.stub(:current_user).and_return(user)
        end

        it "should delete questions of user" do
          user.points.should_receive(:delete_all)
          post :create, params
        end

        it "should set retake quiz in session to true" do
          post :create, params
          session[:profile_retake].should be_true
        end

        it "should redirect to showroom" do
          post :create, params
          response.should redirect_to member_showroom_path
        end
      end

      context "when has answers in user" do
        let(:answer) { SurveyAnswer.new }

        before :each do
          ProfileBuilder.stub(:factory)
          user.stub(:survey_answer).and_return(answer)
          controller.stub(:current_user).and_return(user)
        end

        it "should delete answers of user" do
          answer.should_receive(:delete)
          post :create, params
        end

        it "should set retake quiz in session to true" do
          post :create, params
          session[:profile_retake].should be_true
        end

        it "should redirect to showroom" do
          post :create, params
          response.should redirect_to member_showroom_path
        end
      end

      context "when no has point in user" do
        it "should set retake quiz in session to false" do
          ProfileBuilder.stub(:factory)
          post :create, params
          session[:profile_retake].should be_false
        end

        it "should redirect to welcome" do
          ProfileBuilder.stub(:factory)
          post :create, params
          response.should redirect_to member_welcome_path
        end
      end
    end
  end
end
