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
    end

    describe "GET index" do
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
   end
end

