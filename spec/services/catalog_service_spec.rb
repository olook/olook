require 'spec_helper'

describe CatalogService do
  let(:catalog) do
    moment  = Factory.create :moment
    moment.catalog
  end
  
  let(:product) { 
    product = Factory.create :basic_shoe
    Catalog::Product.create :catalog => moment.catalog, :product => product
  }
  
  before :each do
    Liquidation.delete_all
    Catalog::Product.delete_all
    Product.delete_all
  end

  def products_ids
    Product.all.map(&:id).join(",").sav
  end

  def mock_variant size
    variant = mock Variant
    variant.stub(:description).and_return(size)
    variant
  end

  def mock_detail token
    detail = mock Detail
    detail.stub(:translation_token).and_return(token)
    detail
  end
  
  describe "number of rows" do
    it "should insert one row per shoe size for the same shoe" do
      FactoryGirl.create(:basic_shoe_size_40)
      FactoryGirl.create(:basic_shoe_size_37, :product => Product.last)
      Variant.count.should == 2
      Product.count.should == 1
      expect {
        CatalogService.new(catalog, Product.last, :discount => 50).save
      }.to change(Catalog::Product, :count).by(2)
    end
    
    it "should insert only 1 row for products that are not shoes" do
      product = FactoryGirl.create(:basic_bag)
      expect {
         CatalogService.new(catalog, product, :discount => 50).save
      }.to change(Catalog::Product, :count).by(1)
    end
  end


  it "should calculate the retail price based on the discount percent" do
    product = mock Product
    product.stub(:price).and_return 100.90
    CatalogService.new(catalog, product, :discount => 50).retail_price.should == BigDecimal("50.45")
  end
  
  describe "update" do
    it "should update the price for all variants" do
      FactoryGirl.create(:basic_shoe_size_35)
      product = Product.last
      FactoryGirl.create(:basic_shoe_size_37, :product => product)
      CatalogService.new(catalog, product, :discount => 10).save
      Catalog::Product.all.map{|lp| lp.discount_percent }.should == [10, 10]
    end
  end

end
