# -*- encoding : utf-8 -*-
require 'spec_helper'

describe ProductController do
  with_a_logged_user do
    render_views
    let(:variant) { FactoryGirl.create(:basic_shoe_size_35) }
    let(:product) { variant.product }

    describe "GET index" do
      it "should load and display the product" do
        get :show, :id => product.id
        assigns(:product).should == product
      end

      it "should assigns @variants" do
        get :show, :id => product.id
        assigns(:variants).should == product.variants
      end
    end

    describe "POST add_to_card" do
      it "should redirect back to product page" do
        post :add_to_cart, :variant => {:id => variant.id}
        response.should redirect_to(product_path(product))
      end

      it "should add a variant in the order" do
        Order.any_instance.should_receive(:add_variant).with(variant)
        post :add_to_cart, :variant => {:id => variant.id}
      end
    end
  end
end

