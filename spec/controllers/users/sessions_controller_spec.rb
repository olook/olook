# -*- encoding : utf-8 -*-
require 'spec_helper'

describe Users::SessionsController do

  render_views
  before :each do
    request.env['devise.mapping'] = Devise.mappings[:user]
  end
  let(:user) { FactoryGirl.create(:user) }
  let(:user_params) {{ :email => user.email, :password => user.password }}
  let(:gift_user) { FactoryGirl.create(:user, :gender => User::Gender[:male], :half_user => true, :registered_via => User::ResgisteredVia[:gift]) }
  let(:gift_user_params) {{ :email => gift_user.email, :password => gift_user.password }}
  let(:thin_user) { FactoryGirl.create(:user, :gender => User::Gender[:male], :half_user => true, :registered_via => User::ResgisteredVia[:thin]) }
  let(:thin_user_params) {{ :email => thin_user.email, :password => thin_user.password }}
  
  describe "sign out" do
    it "should add event of sign out" do
      controller.stub(:current_user).and_return(user)
      user.should_receive(:add_event).with(EventType::SIGNOUT)
      post :destroy
    end
  end
  
  describe "sign in" do
    xit "should add event of sign in" do
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

      it "should assign gift products to user" do
        controller.should_receive(:assign_gift)
        post :create, :user => user_params
      end

      it "should add products to cart" do
        controller.should_receive(:assign_gift)
        post :create, :user => user_params
      end

      it "should redirect to cart page" do
        controller.should_receive(:assign_gift)
        post :create, :user => user_params
      end
    end

    context "when has offline product in session" do
       it "should add products to cart"
       it "should redirect to cart page"
    end

    context "when is as full user" do
       it "should redirect to showroom page" do
         post :create, :user => user_params
         response.should redirect_to(member_showroom_path)
       end
    end

    context "when is as half user and registered via gift" do
       it "should redirect to gift page" do
         post :create, :user => gift_user_params
         response.should redirect_to(gift_root_path)
       end
    end

    context "when is as half user and registered via thin" do
       it "should redirect to look book page" do
         post :create, :user => thin_user_params
         response.should redirect_to(lookbooks_path)
       end
    end
  end
end
