# -*- encoding : utf-8 -*-
require 'spec_helper'

describe Users::SessionsController do

  before :each do
    request.env['devise.mapping'] = Devise.mappings[:user]
  end
  
  after :each do
    session[:cart_id] = nil
    session[:recipient_id] = nil
    session[:occasion_id] = nil
  end
  
  
  let!(:user) { FactoryGirl.create(:user) }
  let(:user_params) {{ :email => user.email, :password => user.password }}
  let!(:man_user) { FactoryGirl.create(:user, :gender => User::Gender[:male], :half_user => true, :registered_via => User::RegisteredVia[:gift]) }
  let(:man_user_params) {{ :email => man_user.email, :password => man_user.password }}
  let!(:woman_user) { FactoryGirl.create(:user, :gender => User::Gender[:female], :half_user => true, :registered_via => User::RegisteredVia[:thin]) }
  let(:woman_user_params) {{ :email => woman_user.email, :password => woman_user.password }}

  let!(:loyalty_program_credit_type) { FactoryGirl.create(:loyalty_program_credit_type, :code => :loyalty_program) }
  let!(:invite_credit_type) { FactoryGirl.create(:invite_credit_type, :code => :invite) }
  let!(:redeem_credit_type) { FactoryGirl.create(:redeem_credit_type, :code => :redeem) }
  
  describe "sign out" do
    it "should add event of sign out" do
      post :create, :user => user_params
      expect {
        post :destroy
        last_event = Event.last
        last_event.user_id.should be(user.id)
        last_event.event_type.should be(EventType::SIGNOUT)
      }.to change{Event.count}.by(1)
      
    end
  end
  
  describe "sign in" do
    it "should add event of sign in" do
      expect {
        post :create, :user => user_params
        last_event = Event.last
        last_event.user_id.should be(user.id)
        last_event.event_type.should be(EventType::SIGNIN)
      }.to change{Event.count}.by(1)
    end
    
    context "with cart for gift in session" do
      let (:recipient) { FactoryGirl.create(:gift_recipient, :user => nil) }
      let (:occasion) { FactoryGirl.create(:gift_occasion, :user => nil, :gift_recipient => recipient) }
      let (:cart) { FactoryGirl.create(:cart_with_gift) }

      before(:each) do
        session[:recipient_id] = recipient.id
        session[:occasion_id] = occasion.id
        session[:cart_id] = cart.id
      end
      
      it "should update gift occassion with user" do
        post :create, :user => user_params
        occasion.reload.user_id.should be(controller.current_user.id)
      end

      it "should update gift recipient with user" do
        post :create, :user => user_params
        recipient.reload.user_id.should be(controller.current_user.id)
      end
      
      it "should update cart with user" do
        post :create, :user => user_params
        cart.reload.user_id.should be(controller.current_user.id)
      end

      it "should redirect to new_checkout page when user has credits" do
        user.user_credits_for(:invite).add(amount: 50)
        post :create, :user => user_params
        response.should redirect_to(new_checkout_url(protocol: 'https'))
      end

      it "should redirect to new_checkout page" do
        post :create, :user => user_params
        response.should redirect_to(new_checkout_url(protocol: 'https'))
      end
    end

    context "with cart in session" do
      let (:cart) { FactoryGirl.create(:cart_with_items) }

      before  :each do
        session[:cart_id] = cart.id
      end
      
      it "should update cart with user" do
        post :create, :user => user_params
        cart.reload.user_id.should be(controller.current_user.id)
      end
      
      it "should redirect to new_checkout page when user has credits" do
        user.user_credits_for(:invite).add(amount: 50)
        post :create, :user => user_params
        response.should redirect_to(new_checkout_url(protocol: 'https'))
      end

      it "should redirect to new_checkout page" do
        post :create, :user => user_params
        response.should redirect_to(new_checkout_url(protocol: 'https'))
      end
    end

    context "when is as full user" do
      it "should redirect to showroom page" do
        user.stub(:half_user => false)
        post :create, :user => user_params
        response.should redirect_to(member_showroom_path)
      end
    end

    context "when is as half user and is man" do
      it "should redirect to gift page" do
        post :create, :user => man_user_params
        response.should redirect_to(gift_root_path)
      end
    end

    context "when is as half user and is woman" do
      it "should redirect to showroom page" do
        post :create, :user => woman_user_params
        response.should redirect_to(member_showroom_path)
      end
    end
  end
end
