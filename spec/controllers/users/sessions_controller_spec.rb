# -*- encoding : utf-8 -*-
require 'spec_helper'

describe Users::SessionsController do

  render_views
  before :each do
    request.env['devise.mapping'] = Devise.mappings[:user]
  end
  let(:user) { FactoryGirl.create(:user) }
  let(:user_params) {{ :email => user.email, :password => user.password }}
  let(:man_user) { FactoryGirl.create(:user, :gender => User::Gender[:male], :half_user => true, :registered_via => User::ResgisteredVia[:gift]) }
  let(:man_user_params) {{ :email => man_user.email, :password => man_user.password }}
  let(:woman_user) { FactoryGirl.create(:user, :gender => User::Gender[:female], :half_user => true, :registered_via => User::ResgisteredVia[:thin]) }
  let(:woman_user_params) {{ :email => woman_user.email, :password => woman_user.password }}
  
  describe "sign out" do
    it "should add event of sign out" do
      controller.stub(:current_user).and_return(user)
      user.should_receive(:add_event).with(EventType::SIGNOUT)
      post :destroy
    end
  end
  
  describe "sign in" do
    it "should add event of sign in" do
      controller.stub(:create)
      controller.stub(:current_user).and_return(user)
      user.should_receive(:add_event).with(EventType::SIGNIN)
      post :create, user_params
    end
    
    context "when has gift product in session" do
      before :each do
        session[:gift_products] = mock
      end
      
      after :each do
        session[:gift_products] = nil
      end

      it "should invoke CartBuilder to add Products" do
        CartBuilder.should_receive(:gift).and_return(cart_path)
        post :create, :user => user_params
      end

      it "should redirect to cart page" do
        CartBuilder.should_receive(:gift).and_return(cart_path)
        post :create, :user => user_params
        response.should redirect_to(cart_path)
      end
    end

    context "when has offline product in session" do
      before :each do
        session[:offline_variant] = mock
      end
      
      after :each do
        session[:offline_variant] = nil
      end
      
      it "should invoke CartBuilder to add Products" do
        CartBuilder.should_receive(:offline).and_return(cart_path)
        post :create, :user => user_params
      end

      it "should redirect to cart page" do
        CartBuilder.should_receive(:offline).and_return(cart_path)
        post :create, :user => user_params
        response.should redirect_to(cart_path)
      end
    end

    context "when is as full user" do
      it "should redirect to showroom page" do
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
