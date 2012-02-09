# -*- encoding : utf-8 -*-
require 'spec_helper'

describe ProductController do
  with_a_logged_user do
    render_views
    let(:variant) { FactoryGirl.create(:basic_shoe_size_35) }
    let(:product) { variant.product }
    let(:order) { FactoryGirl.create(:order, :user => user).id }

    before :each do
      session[:order] = order
      FactoryGirl.create(:main_picture, :product => product)
    end

    describe "GET show" do
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

      it "should assigns @order" do
        get :show, :id => product.id
        assigns(:order).should == Order.find(order)
      end
    end

    describe "POST create_offline_session" do
      it "should assigns params[:variant] to session[:offline_variant]" do
        variant = { "id" => "1234" }
        post :create_offline_session, :variant => variant
        session[:offline_variant].should be_eql(variant)
        session[:offline_first_access].should be_true
      end
    end
  end
end

