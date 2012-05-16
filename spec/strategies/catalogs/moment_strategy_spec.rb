require 'spec_helper'

describe Catalogs::MomentStrategy do
  let(:basic_bag) do
    product = (FactoryGirl.create :bag_subcategory_name).product
    product.master_variant.price = 100.00
    product.master_variant.save!

    FactoryGirl.create :basic_bag_simple, :product => product

    product
  end

  let(:moment1) { FactoryGirl.create :moments }
  let(:moment2) { FactoryGirl.create :moments }
  let(:moment3) { FactoryGirl.create :moments }

  describe "save product in catalog" do
    it "should insert without moments" do
      expect {
        Catalogs::MomentStrategy.new(basic_bag, :test_options => true).save
      }.to_not raise_error
    end

    it "should insert" do
      ct_product_service = double(CatalogProductService)
      ct_product_service.should_receive(:save!)

      CatalogProductService.should_receive(:new)
                           .with(moment1.catalog, basic_bag, :test_options => true)
                           .and_return(ct_product_service)
      Catalogs::MomentStrategy.new(basic_bag, :moments => [moment1], :test_options => true).save
    end
  end

  describe "destroy product in catalog" do
    before :each do
      CatalogProductService.new(moment1.catalog, basic_bag).save!
    end

    it "should destroy" do
      ct_product_service = double(CatalogProductService)
      ct_product_service.should_receive(:destroy)

      CatalogProductService.should_receive(:new)
                           .with(moment1.catalog, basic_bag, {})
                           .and_return(ct_product_service)

      Catalogs::MomentStrategy.new(basic_bag, :moments => []).destroy
    end

  end

  describe "seek and destroy" do
    it "should create a row in the database" do
      moment_strategy = Catalogs::MomentStrategy.new(basic_bag, :moments => [moment1])
      expect {
        moment_strategy.seek_and_destroy!
      }.to change{moment1.catalog.products.count}.by(1)
    end

    it "should remove a row in the database" do
      moment_strategy = Catalogs::MomentStrategy.new(basic_bag, :moments => [moment1])
      moment_strategy.seek_and_destroy!
      expect {
        moment_strategy = Catalogs::MomentStrategy.new(basic_bag, :moments => [])
        moment_strategy.seek_and_destroy!
      }.to change{moment1.catalog.products.count}.by(-1)
    end

    it "should remove only one row in the database" do
      moment_strategy = Catalogs::MomentStrategy.new(basic_bag, :moments => [moment1, moment2])
      moment_strategy.seek_and_destroy!
      expect {
        moment_strategy = Catalogs::MomentStrategy.new(basic_bag, :moments => [moment1])
        moment_strategy.seek_and_destroy!
      }.to change{moment1.catalog.products.count + moment2.catalog.products.count}.by(-1)
    end

    it "should call the right methods" do
      moment_strategy = Catalogs::MomentStrategy.new(basic_bag)
      moment_strategy.should_receive(:save)
      moment_strategy.should_receive(:destroy)
      moment_strategy.seek_and_destroy!
    end
  end
end

