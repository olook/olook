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

    it "should be success" do
      response.should be_success
    end
  end

  describe "GET mt_perfomance" do

    let!(:variant) { FactoryGirl.create(:variant, :is_master => true, :price => 2.2) }
    let!(:product) { variant.product }

    it "gets only products for xml" do
      Product.should_receive(:for_xml)
      get :mt_performance
    end

    it "assigns all produts for xml to @products" do
      get :mt_performance
      assigns(:products).should include(product)
    end

    it "should be success" do
      response.should be_success
    end
  end

  describe "GET click_a_porter" do

    let!(:variant) { FactoryGirl.create(:variant, :is_master => true, :price => 2.2) }
    let!(:product) { variant.product }

    it "gets only products for xml" do
      Product.should_receive(:for_xml)
      get :click_a_porter
    end

    it "assigns all produts for xml to @products" do
      get :click_a_porter
      assigns(:products).should include(product)
    end

    it "should be success" do
      response.should be_success
    end
  end


end
