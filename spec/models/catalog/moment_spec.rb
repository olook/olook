require 'spec_helper'

describe Catalog::Moment do
  it { should belong_to(:moment) }
  
  let(:basic_bag) do
    product = (Factory.create :bag_subcategory_name).product
    product.master_variant.price = 100.00
    product.master_variant.save!
    
    Factory.create :basic_bag_simple, :product => product

    product
  end
  
  let(:moment1) { Factory.create :moments }
  let(:moment2) { Factory.create :moments }
  let(:moment3) { Factory.create :moments }
  
  describe "save product in catalog" do
    it "should insert without moments" do
      expect {
        Catalog::Moment.save_product basic_bag, :test_options => true
      }.to_not raise_error
    end
    
    it "should insert" do
      
      ct_product_service = double(CatalogProductService)
      ct_product_service.should_receive(:save!)
      
      CatalogProductService.should_receive(:new)
                           .with(moment1.catalog, basic_bag, :test_options => true)
                           .and_return(ct_product_service)
                           
      Catalog::Moment.save_product basic_bag, :moments => [moment1], :test_options => true
    end
  end
  
  describe "destroy product in catalog" do
    before :each do
      CatalogProductService.new(moment1.catalog, basic_bag)
      CatalogProductService.new(moment2.catalog, basic_bag)
      CatalogProductService.new(moment3.catalog, basic_bag)
    end
    
    it "should destroy" do
      
      ct_product_service = double(CatalogProductService)
      ct_product_service.should_receive(:destroy!)
      
      CatalogProductService.should_receive(:new)
                           .with(moment2.catalog, basic_bag)
                           .and_return(ct_product_service)

     ct_product_service = double(CatalogProductService)
     ct_product_service.should_receive(:destroy!)

     CatalogProductService.should_receive(:new)
                          .with(moment3.catalog, basic_bag)
                          .and_return(ct_product_service)
      
      Catalog::Moment.save_product basic_bag, :moments => [moment1]
    end
  end
end
