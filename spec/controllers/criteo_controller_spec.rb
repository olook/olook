require 'spec_helper'

describe CriteoController do
  describe "GET show" do

    let!(:variant) { FactoryGirl.create(:variant, :is_master => true, :price => 2.2) }
    let!(:product) { variant.product }

    it "gets only products for criteo" do
      Product.should_receive(:for_criteo)
      get :show
    end

    it "assigns all produts for criteo to @products" do
      get :show
      assigns(:products).should include(product)
    end
  end
end
