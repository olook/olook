require 'spec_helper'

describe CatalogService do
  let(:basic_bag) do
    product = (Factory.create :bag_subcategory_name).product
    product.master_variant.price = 100.00
    product.master_variant.save!
    
    Factory.create :basic_bag_simple, :product => product

    product
  end
  
  describe "save product" do
    it "should execute moment catalogs insert strategy" do
      Catalog::Moment.should_receive(:save_product)
                     .with(basic_bag, {:test_options => true})
                     
      CatalogService.save_product basic_bag, :test_options => true
    end
  end
end
