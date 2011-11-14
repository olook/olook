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
    it "assigns all users as @users" do
      get :index
      assigns(:users).should eq([user])
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
      record = [ user.first_name,
        user.last_name,
        user.email,
        user.is_invited? ? 'invited' : 'organic',
        user.created_at.to_s(:short),
        user.profile_scores.first.try(:profile).try(:name),
        accept_invitation_url(:invite_token => user.invite_token),
        user.events.where(:type => EventType::TRACKING).first.try(:description)
      ]      
      get :export
      assigns(:records).should eq([record])
    end
  end
end
