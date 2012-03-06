require 'spec_helper'

describe LiquidationProductService do
  let(:liquidation) { FactoryGirl.create(:liquidation) }

  def products_ids
    Product.all.map(&:id).join(",")
  end
  
  describe "number of rows" do
    it "should insert one row per shoe size for the same shoe" do
      product = mock Product
      product.stub(:category).and_return(1) #shoe
      #maybe use factories here instead of stubing
      product.stub(:variants).and_return(["33", "34", "35"])
      expect {
        LiquidationProductService.new(liquidation, product, 50)
      }.to change(LiquidationProduct, :count).by(3)
    end
    
    it "should insert only 1 row for products that are not shoes" do
      product = mock Product
      product.stub(:category).and_return(2) #bag
      product.stub(:variants).and_return(["x", "y", "z"])
      expect {
        LiquidationProductService.new(liquidation, product, 50)
      }.to change(LiquidationProduct, :count).by(1)
    end
  end


  it "should calculate the retail price based on the discount percent" do
    product = mock Product
    product.stub(:price).and_return 100.90
    LiquidationProductService.new(liquidation, product, 50).retail_price.should == BigDecimal("50.45")
  end
end
