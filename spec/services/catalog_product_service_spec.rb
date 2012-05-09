require 'spec_helper'

describe CatalogProductService do
  let(:catalog) do
    moment  = Factory.create :moment
    moment.catalog
  end
  
  let(:basic_bag) { 
    product = (Factory.create :bag_subcategory_name).product
    product.master_variant.price = 100.00
    product.master_variant.save!
    
    Factory.create :basic_bag_simple, :product => product

    product
  }

  it "should calculate the retail price based on the discount percent" do
    product = mock Product
    product.stub(:price).and_return 100.90
    CatalogProductService.new(catalog, product, :discount_percentage => 50).retail_price.should == BigDecimal("50.45")
  end

  describe "insert a product" do
    it "should insert without discount for bag product" do
      expect {
         ct_product = CatalogProductService.new(catalog, basic_bag).save!         
         
         ct_product.catalog_id.should  eq catalog.id
         ct_product.product_id.should  eq basic_bag.id
         ct_product.category_id.should eq basic_bag.category
         
         ct_product.subcategory_name.should eq "bolsa-azul"
         ct_product.subcategory_name_label.should eq "Bolsa Azul"

         ct_product.original_price.should eq 100.0
         ct_product.retail_price.should eq 100.0
         ct_product.discount_percent.should eq 0
         ct_product.variant_id.should eq basic_bag.variants.first.id
         ct_product.inventory.should eq 10
      }.to change(catalog.products, :count).by(1)
    end
    
    pending "should insert with discount" do
      expect {
         CatalogProductService.new(catalog, basic_bag, :discount_percentage => 50).save
      }.to change(Catalog::Product, :count).by(1)
    end
    
    pending "should insert one row per variant" do
      FactoryGirl.create(:basic_shoe_size_40)
      FactoryGirl.create(:basic_shoe_size_37, :product => Product.last)
      Variant.count.should == 2
      Product.count.should == 1
      expect {
        CatalogProductService.new(Product.last, :discount_percentage => 50, :moments => [catalog]).save
      }.to change(Catalog::Product, :count).by(2)
    end
  end

  
  pending "update a product" do
    it "should update info has only master variant"
    
    it "should update info for all row per variant"
    
    context "when update price" do
      pending "should update the price for product without variant" do
        FactoryGirl.create(:basic_shoe_size_35)
        product = Product.last
        FactoryGirl.create(:basic_shoe_size_37, :product => product)
        CatalogProductService.new(product, :discount_percentage => 10, :moments => [catalog]).save
        Catalog::Product.all.map{|lp| lp.discount_percent }.should == [10, 10]
      end

      it "should update the price for product with variant" do
        FactoryGirl.create(:basic_shoe_size_35)
        product = Product.last
        FactoryGirl.create(:basic_shoe_size_37, :product => product)
        CatalogProductService.new(product, :discount_percentage => 10, :moments => [catalog]).save
        Catalog::Product.all.map{|lp| lp.discount_percent }.should == [10, 10]
      end
    end
  end
end
