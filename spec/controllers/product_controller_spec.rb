# -*- encoding : utf-8 -*-
require 'spec_helper'

describe ProductController do
  render_views
  let(:product) { FactoryGirl.create(:basic_shoe) }

  describe "#index" do
    it "should load and display the product" do
      get :index, :id => product.id
      assigns(:product).should == product
      response.should render_template(:index)
    end
  end
end
