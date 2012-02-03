require 'spec_helper'

describe Lookbook do
	let!(:product)      { FactoryGirl.create(:basic_shoe) }
	let!(:lookbook)      { FactoryGirl.create(:complex_lookbook, 
												:product_list => { "#{product.id}" => "1" }, 
												:product_criteo => { "#{product.id}" => "1" } ) }
  
  describe "validation" do
    it { should validate_presence_of(:name) }
    it { should have_many(:images) }
    it { should have_many(:lookbooks_products) }
    it { should have_many(:products) }
  end

  describe "Check if products related were updated" do

    it "Chekc if product was related" do
    	lookbook.products[0].should eq(product)
    end

    it "Check if product related is displayed in criteo" do
    	lookbook.lookbooks_products[0].criteo.should eq(true)
    end
    
  end

end