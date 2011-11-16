# -*- encoding : utf-8 -*-
require 'spec_helper'

describe ProductController do
  with_a_logged_user do
    render_views
    let(:product) { FactoryGirl.create(:basic_shoe) }

    describe "GET index" do
      it "should load and display the product" do
        get :index, :id => product.id
        assigns(:product).should == product
      end
    end
  end
end
