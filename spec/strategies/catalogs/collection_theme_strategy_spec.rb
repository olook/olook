require 'spec_helper'

describe Catalogs::CollectionThemeStrategy do
  let(:basic_bag) do
    product = (FactoryGirl.create :bag_subcategory_name).product
    product.master_variant.price = 100.00
    product.master_variant.save!

    FactoryGirl.create :basic_bag_simple, :product => product

    product
  end

  let(:collection_theme1) { FactoryGirl.create :collection_themes }
  let(:collection_theme2) { FactoryGirl.create :collection_themes }
  let(:collection_theme3) { FactoryGirl.create :collection_themes }

  describe "save product in catalog" do
    it "should insert without collection_themes" do
      expect {
        Catalogs::CollectionThemeStrategy.new(basic_bag, :test_options => true).save
      }.to_not raise_error
    end

    it "should insert" do
      ct_product_service = double(CatalogProductService)
      ct_product_service.should_receive(:save!)

      CatalogProductService.should_receive(:new)
                           .with(collection_theme1.catalog, basic_bag, :test_options => true)
                           .and_return(ct_product_service)
      Catalogs::CollectionThemeStrategy.new(basic_bag, :collection_themes => [collection_theme1], :test_options => true).save
    end
  end

  describe "destroy product in catalog" do
    before :each do
      CatalogProductService.new(collection_theme1.catalog, basic_bag).save!
    end

    it "should destroy" do
      ct_product_service = double(CatalogProductService)
      ct_product_service.should_receive(:destroy)

      CatalogProductService.should_receive(:new)
                           .with(collection_theme1.catalog, basic_bag, {})
                           .and_return(ct_product_service)

      Catalogs::CollectionThemeStrategy.new(basic_bag, :collection_themes => []).destroy
    end

  end

  describe "seek and destroy" do
    it "should create a row in the database" do
      collection_theme_strategy = Catalogs::CollectionThemeStrategy.new(basic_bag, :collection_themes => [collection_theme1])
      expect {
        collection_theme_strategy.seek_and_destroy!
      }.to change{collection_theme1.catalog.products.count}.by(1)
    end

    it "should remove a row in the database" do
      collection_theme_strategy = Catalogs::CollectionThemeStrategy.new(basic_bag, :collection_themes => [collection_theme1])
      collection_theme_strategy.seek_and_destroy!
      expect {
        collection_theme_strategy = Catalogs::CollectionThemeStrategy.new(basic_bag, :collection_themes => [])
        collection_theme_strategy.seek_and_destroy!
      }.to change{collection_theme1.catalog.products.count}.by(-1)
    end

    it "should remove only one row in the database" do
      collection_theme_strategy = Catalogs::CollectionThemeStrategy.new(basic_bag, :collection_themes => [collection_theme1, collection_theme2])
      collection_theme_strategy.seek_and_destroy!
      expect {
        collection_theme_strategy = Catalogs::CollectionThemeStrategy.new(basic_bag, :collection_themes => [collection_theme1])
        collection_theme_strategy.seek_and_destroy!
      }.to change{collection_theme1.catalog.products.count + collection_theme2.catalog.products.count}.by(-1)
    end

    it "should call the right methods" do
      collection_theme_strategy = Catalogs::CollectionThemeStrategy.new(basic_bag)
      collection_theme_strategy.should_receive(:save)
      collection_theme_strategy.should_receive(:destroy)
      collection_theme_strategy.seek_and_destroy!
    end
  end
end

