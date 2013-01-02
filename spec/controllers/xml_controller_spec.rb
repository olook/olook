require 'spec_helper'
 
describe XmlController do
  let!(:product_with_variant) { FactoryGirl.create :blue_sliper_with_variants }
  describe "GET criteo" do

    it "gets only products for xml" do
      Product.should_receive(:load_criteo_config).with("products_blacklist").and_return([1,2,3])
      Product.should_receive(:load_criteo_config).with("collections_blacklist").and_return([4,5,6])
      Product.should_receive(:valid_criteo_for_xml).with([1,2,3],[4,5,6])
      get :criteo
    end

    it "assigns all produts for xml to @products" do
      stub_scope_params
      get :criteo
      assigns(:products).should include(product_with_variant)
    end

    it "should be success" do
      response.should be_success
    end
  end

  describe "GET mt_perfomance" do
    let!(:variant) { FactoryGirl.create(:variant, :is_master => true, :price => 2.2) }
    let!(:product) { variant.product }

    it "gets only products for xml" do
      stub_scope_params
      Product.should_receive(:valid_for_xml).with([0],[0])
      get :mt_performance
    end

    it "assigns all produts for xml to @products" do
      stub_scope_params
      get :mt_performance
      assigns(:products).should include(product_with_variant)
    end

    it "should be success" do
      response.should be_success
    end
  end

  describe "GET click_a_porter" do

    it "gets only products for xml" do
      Product.should_receive(:valid_for_xml)
      get :click_a_porter
    end

    it "assigns all produts for xml to @products" do
      stub_scope_params
      get :click_a_porter
      assigns(:products).should include(product_with_variant)
    end

    it "should be success" do
      response.should be_success
    end
  end

  describe "GET sociomantic" do

    it "gets only products for xml" do
      Product.should_receive(:valid_for_xml)
      get :sociomantic
    end

    it "assigns all produts for xml to @products" do
      stub_scope_params
      get :sociomantic
      assigns(:products).should include(product_with_variant)
    end

    it "should be success" do
      response.should be_success
    end
  end


  describe "GET zanox" do

    it "gets only products for xml" do
      Product.should_receive(:valid_for_xml)
      get :zanox
    end

    it "assigns all produts for xml to @products" do
      stub_scope_params
      get :zanox
      assigns(:products).should include(product_with_variant)
    end

    it "should be success" do
      response.should be_success
    end
  end

  describe "GET topster" do

    it "gets only products for xml" do
      Product.should_receive(:valid_for_xml)
      get :topster
    end

    it "assigns all produts for xml to @products" do
      stub_scope_params
      get :topster
      assigns(:products).should include(product_with_variant)
    end

    it "should be success" do
      response.should be_success
    end
  end

  describe "GET netaffiliation" do

    it "gets only products for xml" do
      Product.should_receive(:valid_for_xml)
      get :netaffiliation
    end

    it "assigns all produts for xml to @products" do
      stub_scope_params
      get :netaffiliation
      assigns(:products).should include(product_with_variant)
    end

    it "should be success" do
      response.should be_success
    end
  end

  describe "GET shopping_uol" do

    it "gets only products for xml" do
      Product.should_receive(:valid_for_xml)
      get :shopping_uol
    end

    it "assigns all produts for xml to @products" do
      stub_scope_params
      get :shopping_uol
      assigns(:products).should include(product_with_variant)
    end

    it "should be success" do
      response.should be_success
    end
  end

  describe "GET triggit" do

    it "gets only products for xml" do
      Product.should_receive(:valid_for_xml)
      get :triggit
    end

    it "assigns all produts for xml to @products" do
      stub_scope_params
      get :triggit
      assigns(:products).should include(product_with_variant)
    end

    it "should be success" do
      response.should be_success
    end
  end

  describe "GET google_shopping" do

    it "gets only products for xml" do
      Product.should_receive(:valid_for_xml)
      get :google_shopping
    end

    it "assigns all produts for xml to @products" do
      stub_scope_params
      get :google_shopping
      assigns(:products).should include(product_with_variant)
    end

    it "should be success" do
      response.should be_success
    end
  end

  def stub_scope_params
    Product.should_receive(:load_criteo_config).with("products_blacklist").and_return([0])
    Product.should_receive(:load_criteo_config).with("collections_blacklist").and_return([0])
  end

end
