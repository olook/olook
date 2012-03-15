require 'spec_helper'

describe Liquidation do
  
  before :each do
    Liquidation.delete_all
    LiquidationProduct.delete_all
  end
  
  describe "validation" do
    it { should have_many(:liquidation_products) }
    it { should have_many(:liquidation_carousels) }
    it { should validate_presence_of(:name) }
  end

  it "should not update the liquidation if the change on the period conflicts with existing products" do
  	#[:january_2012_collection, :february_2012_collection, :march_2012_collection].each do |collection|
  	#	FactoryGirl.create(collection)
  	#end
  	#liquidation = FactoryGirl.create(:liquidation, :starts_at => "07/03/2012", :ends_at => "14/03/2012")
  	#product = FactoryGirl.create(:basic_shoe, :collection_id => 2) #feb
  	#liquidation.liquidation_products.create(:liquidation_id => liquidation.id, :product_id => product.id)
  	#liquidation.starts_at = "01/02/2012"
  	#liquidation.save.should be_false
 	  #liquidation.should have(1).error_on(:starts_at)
  end
end
