require 'spec_helper'

describe CatalogService do
  let(:basic_bag) do
    product = (FactoryGirl.create :bag_subcategory_name).product
    product.master_variant.price = 100.00
    product.master_variant.save!

    FactoryGirl.create :basic_bag_simple, :product => product

    product
  end

  let(:collection_theme1) { FactoryGirl.create :collection_themes }

  describe "save product" do
    it "should update product in catalogs" do
      CatalogProductService.new(collection_theme1.catalog, basic_bag).save!

      ct_product_service = double(CatalogProductService)
      ct_product_service.should_receive(:save!)
      CatalogProductService.should_receive(:new)
                     .with(collection_theme1.catalog, basic_bag, {:test_options => true}).and_return(ct_product_service)

      CatalogService.save_product basic_bag, :test_options => true
    end

    it "should not execute collection_theme catalogs without collection_themes" do
      Catalogs::CollectionThemeStrategy.should_not_receive(:new)
      CatalogService.save_product basic_bag, :test_options => true
    end

    it "should execute collection_theme catalogs when has collection_themes" do
      ct_collection_theme_strategy = double(Catalogs::CollectionThemeStrategy)
      ct_collection_theme_strategy.should_receive(:seek_and_destroy!)
      Catalogs::CollectionThemeStrategy.should_receive(:new)
                     .with(basic_bag, {:test_options => true, :collection_themes => []}).and_return(ct_collection_theme_strategy)
      CatalogService.save_product basic_bag, :test_options => true, :collection_themes => []
    end
  end
end
