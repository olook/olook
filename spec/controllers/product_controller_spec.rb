# -*- encoding : utf-8 -*-
require 'spec_helper'

describe ProductController do
  with_a_logged_user do
    render_views
    let(:variant) { FactoryGirl.create(:basic_shoe_size_35) }
    let(:product) { variant.product }
    # let!(:user_info) { FactoryGirl.create(:user_info, :user => user) }
    let(:order) { FactoryGirl.create(:order, :user => user).id }
    let!(:loyalty_program_credit_type) { FactoryGirl.create(:loyalty_program_credit_type, :code => :loyalty_program) }
    let!(:invite_credit_type) { FactoryGirl.create(:invite_credit_type, :code => :invite) }
    let!(:redeem_credit_type) { FactoryGirl.create(:redeem_credit_type, :code => :redeem) }
    
    before :each do
      session[:order] = order
      product.master_variant.price = 29.90
      product.master_variant.save!
      FactoryGirl.create(:main_picture, :product => product)
    end

    describe "GET show" do
      it "should assign @only_view" do
        get :show, :id => product.id
        assigns(:only_view).should eq(false)
      end

      it "should assign @only_view when is only view" do
        get :show, :id => product.id, :only_view => "true"
        assigns(:only_view).should eq(true)
      end

      it "should assign @only_view" do
        get :show, :id => product.id
        assigns(:gift).should eq(false)
      end

      it "should assign @gift when has gift" do
        get :show, :id => product.id, :gift => "true"
        assigns(:gift).should eq(true)
      end

      
      it "should assign @shoe_size" do
        get :show, :id => product.id, :shoe_size => "37"
        assigns(:shoe_size).should eq(37)
      end
      
      it "should assign @shoe_size when has invalid integer" do
        get :show, :id => product.id, :shoe_size => "null"
        assigns(:shoe_size).should eq(0)
      end

      it "should assign @shoe_size when has empty params" do
        get :show, :id => product.id
        assigns(:shoe_size).should eq(0)
      end
      
      it "should assign @facebook_app_id" do
        get :show, :id => product.id
        assigns(:facebook_app_id).should eq(FACEBOOK_CONFIG["app_id"])
      end

      it "should assign @url" do
        get :show, :id => product.id
        assigns(:url).should == request.protocol + request.host
      end

      it "should load and display the product" do
        get :show, :id => product.id
        assigns(:product).should == product
      end

      it "should assigns @variants" do
        get :show, :id => product.id
        assigns(:variants).should == product.variants
      end
    end
  end
end

