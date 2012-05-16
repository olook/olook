require 'spec_helper'

describe CatalogService do
  let(:basic_bag) do
    product = (FactoryGirl.create :bag_subcategory_name).product
    product.master_variant.price = 100.00
    product.master_variant.save!

    FactoryGirl.create :basic_bag_simple, :product => product

    product
  end

  let(:moment1) { FactoryGirl.create :moments }

  describe "save product" do
    it "should update product in catalogs" do
      CatalogProductService.new(moment1.catalog, basic_bag).save!
      
      ct_product_service = double(CatalogProductService)
      ct_product_service.should_receive(:save!)
      CatalogProductService.should_receive(:new)
                     .with(moment1.catalog, basic_bag, {:test_options => true}).and_return(ct_product_service)
      
      CatalogService.save_product basic_bag, :test_options => true
    end

    it "should  not execute moment catalogs without moments" do
      Catalogs::MomentStrategy.should_not_receive(:new)
      CatalogService.save_product basic_bag, :test_options => true
    end
        
    it "should execute moment catalogs when has moments" do
      ct_moment_strategy = double(Catalogs::MomentStrategy)
      ct_moment_strategy.should_receive(:seek_and_destroy!)
      Catalogs::MomentStrategy.should_receive(:new)
                     .with(basic_bag, {:test_options => true, :moments => []}).and_return(ct_moment_strategy)
      CatalogService.save_product basic_bag, :test_options => true, :moments => []
    end
  end
end
