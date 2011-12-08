# -*- encoding : utf-8 -*-
require 'spec_helper'

describe RegistrationsController do

  let(:user_attributes) { {"email" => "mail@mail.com", "password" => "123456", "password_confirmation" => "123456", "first_name" => "User Name", "last_name" => "Last Name" } }

  let(:birthday) { {:day => "27", :month => "9", :year => "1987"} }

  before :all do
    ActiveRecord::Base.observers.disable :all
  end
  after :all do
    ActiveRecord::Base.observers.enable :all
  end

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

    it "should assigns @signup_with_facebook" do
      session[:profile_points] = :some_data
      session["devise.facebook_data"] = {"extra" => {"user_hash" => "xyz"}, "credentials" => {"token" => "abc"}}
      get :new
      assigns(:signup_with_facebook).should eq(true)
    end

    it "should build the resource using session data" do
      session[:profile_points] = :some_data
      data = {"email" => "mail@mail.com"}
      controller.stub(:user_data_from_session).and_return(data)
      get :new
      controller.resource.email.should eq("mail@mail.com")
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

    it "should render the edit template" do
      User.any_instance.stub(:update_attributes).and_return(false)
      put :update, :id => @user.id, :user => user_attributes
      response.should render_template('edit')
    end
  end

  describe "POST create with profile_points" do
    it "should create user points" do
      session[:questions] = {:foo => :bar}
      session[:birthday] = birthday
      session[:profile_points] = {1 => 2, 3 => 4}
      subject.should_receive(:save_tracking_params)
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
     user = User.find_by_email(user_attributes["email"])
     user.birthday.to_s.should == "1987-09-27"
    end

    it "should redirect to invite people page" do
      session[:profile_points] = :some_data
      post :create, :user => user_attributes
      response.should redirect_to(member_invite_path)
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
     [:profile_points, :questions, :invite, "devise.facebook_data", :tracking_params].each {|key| session[key].should == nil}
    end
  end

  describe '#save_tracking_params' do
    let(:member) { mock_model(User) }

    it 'should add a new event to the user if there are tracking parameters' do
      member.should_receive(:add_event).with(EventType::TRACKING, {:tracking => 'stuff'}.to_s)
      subject.send(:save_tracking_params, member, {:tracking => 'stuff'})
    end

    describe 'should not add a new event to the user' do
      it 'if the resource is not a User' do
        member.should_not_receive(:add_event)
        subject.send(:save_tracking_params, mock_model(Admin), {:tracking => 'stuff'})
      end

      it 'if there are no tracking parameters' do
        member.should_not_receive(:add_event)
        subject.send(:save_tracking_params, member, nil)
      end
    end
  end
end
