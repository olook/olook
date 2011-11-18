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
    end
  end
end
