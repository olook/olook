# -*- encoding : utf-8 -*-
require 'spec_helper'

describe Admin::UsersController, admin: true do
  render_views
  let!(:user) { FactoryGirl.create(:user) }
  let!(:valid_attributes) { user.attributes }
  let!(:redeem_credit_type) {FactoryGirl.create(:redeem_credit_type, :code => :redeem)}
  let!(:loyalty_program_credit_type) {FactoryGirl.create(:redeem_credit_type, :code => :loyalty_program)}
  let!(:invite_credit_type) {FactoryGirl.create(:redeem_credit_type, :code => :invite)}


  before :each do
    request.env['devise.mapping'] = Devise.mappings[:admin]
    @admin = FactoryGirl.create(:admin_superadministrator)
    sign_in @admin
  end

  describe "GET index" do
    let(:searched_user) { FactoryGirl.create(:user, :first_name => 'ZYX') }
    let(:search_param) { {"first_name_contains" => searched_user.first_name} }

    it "should search for a user using the search parameter" do
      get :index, :search => search_param

      assigns(:users).should_not include(user)
      assigns(:users).should include(searched_user)
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

  describe "GET admin_login" do
    it "allow admin to login as any user" do
      get :admin_login, :id => user.id.to_s
      response.should redirect_to(root_path)
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

  describe 'GET statistics' do
    let(:result) { double(:result, creation_date: Date.civil(2011, 11, 15), daily_total: 10 ) }

    it 'should get the count of created members by date' do
      UserReport.should_receive(:statistics).and_return([result])
      get :statistics
      assigns(:statistics).should eq([result])
    end
  end

  describe 'GET export' do
    it 'should create a new job on Resque with current_admin email' do
      Resque.should_receive(:enqueue).with(Admin::ExportUsersWorker, @admin.email)

      get :export
    end
  end

  describe 'GET lock_access' do
    it 'should set has_fraud to true' do
      get :lock_access, :id => user.id
      user.reload
      user.has_fraud.should be_true
    end
  end

  describe 'GET unlock_access' do
    it 'should set has_fraud to false' do
      get :lock_access, :id => user.id.to_s
      get :unlock_access, :id => user.id.to_s
      user.has_fraud.should be_false
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested user" do
      expect {
        delete :destroy, :id => user.id.to_s
      }.to change(User, :count).by(-1)
    end

    it "redirects to the user list" do
      delete :destroy, :id => user.id.to_s
      response.should redirect_to(admin_users_url)
    end
  end

  describe "POST create_credit_transaction" do
    let(:transaction_param)  do
      { :id => user.id.to_s,
        :value => "10",
        :operation => "redeem:order",
        :reason => "Some reason"
      }
    end

    context 'add' do
      let!(:user_credit) { FactoryGirl.create(:user_credit, :user => user, :credit_type => redeem_credit_type)}

      it "should create a credit transaction, given value, valid operation and reason" do
        User.any_instance.should_receive(:user_credits_for).with('redeem').and_return(user_credit)
        expect do
          post :create_credit_transaction, transaction_param.merge(:order_number => "", :method => :add, :operation => :'redeem:order', :reason => 'foo')
          assigns(:user).should eq(user)
          assigns(:credit_type).should eq('redeem')
        end.to change{Credit.count}.by(1)
      end
    end


    # it "should redirect to the user" do
    #   post :create_credit_transaction, transaction_param
    #   response.should redirect_to(admin_user_path(user))
    # end
  end
end
