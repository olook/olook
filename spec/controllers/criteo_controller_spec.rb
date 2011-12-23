require 'spec_helper'

describe CriteoController do
  describe "GET show" do

    let!(:product) { FactoryGirl.create(:basic_shoe) }

    it "gets only visible products" do
      Product.should_receive(:only_visible)
      get :show
    end

    it "assigns all visible products to @products" do
      get :show
      assigns(:products).should include(product)
    end
  end
end
