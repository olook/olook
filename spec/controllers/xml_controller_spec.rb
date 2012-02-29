require 'spec_helper'

describe XmlController do
  describe "GET criteo" do

    let!(:variant) { FactoryGirl.create(:variant, :is_master => true, :price => 2.2) }
    let!(:product) { variant.product }

    it "gets only products for xml" do
      Product.should_receive(:for_xml)
      get :criteo
    end

    it "assigns all produts for xml to @products" do
      get :criteo
      assigns(:products).should include(product)
    end
  end
end
