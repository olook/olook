# -*- encoding : utf-8 -*-
require 'spec_helper'

describe Admin::UsersController do
  render_views
  let!(:user) { FactoryGirl.create(:user) }
  let!(:valid_attributes) { user.attributes }

  before :each do
    request.env['devise.mapping'] = Devise.mappings[:admin]
    @admin = Factory :admin
    sign_in @admin
  end

  describe "GET index" do
    context 'when no search parameter is provided' do
      it "assigns all users as @users" do
        get :index
        assigns(:users).should eq([user])
      end
    end
    context 'when a search parameter is provided' do
      let(:searched_user) { FactoryGirl.create(:user, :first_name => 'ZYX') }

      it "should filter the users by by name and e-mail using the parameter" do
        get :index, :search => searched_user.first_name
        assigns(:users).should_not include(user)
        assigns(:users).should include(searched_user)
      end
    end
  end

  describe "GET show" do
    it "assigns the requested user as @user" do
      answer = FactoryGirl.create(:answer)
      question = answer.question
      user.create_survey_answer(:answers => {"question_#{question.id}" => answer.id})
      get :show, :id => user.id.to_s
      assigns(:user).should eq(user)
    end
  end

  describe "GET edit" do
    it "assigns the requested user as @user" do
      get :edit, :id => user.id.to_s
      assigns(:user).should eq(user)
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      it "updates the requested user" do
        # Assuming there are no other users in the database, this
        # specifies that the User created on the previous line
        # receives the :update_attributes message with whatever params are
        # submitted in the request.
        User.any_instance.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => user.id, :user => {'these' => 'params'}
      end

      it "assigns the requested user as @user" do
        put :update, :id => user.id, :user => valid_attributes
        assigns(:user).should eq(user)
      end

      it "redirects to the user" do
        put :update, :id => user.id, :user => valid_attributes
        response.should redirect_to([:admin, user])
      end
    end

    describe "with invalid params" do
      it "assigns the user as @user" do
        # Trigger the behavior that occurs when invalid params are submitted
        User.any_instance.stub(:save).and_return(false)
        put :update, :id => user.id.to_s, :user => {}
        assigns(:user).should eq(user)
      end

      it "re-renders the 'edit' template" do
        # Trigger the behavior that occurs when invalid params are submitted
        User.any_instance.stub(:save).and_return(false)
        put :update, :id => user.id.to_s, :user => {}
        flash[:notice].should be_blank
        #response.should render_template("edit")
      end
    end
  end
  
  describe "GET export" do
    it 'should render the list of all users' do
      UserReport.should_receive(:export).and_return([[:result]])
      get :export
      assigns(:records).should eq([[:result]])
    end
  end
  
  describe 'GET statistics' do
    let(:result) { double(:result, creation_date: Date.civil(2011, 11, 15), daily_total: 10 ) }

    it 'should get the count of created members by date' do
      UserReport.should_receive(:statistics).and_return([result])
      get :statistics
      assigns(:statistics).should eq([result])
    end
  end
end
