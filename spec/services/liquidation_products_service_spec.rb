require 'spec_helper'

describe LiquidationProductsService do
  let(:liquidation) { FactoryGirl.create(:liquidation) }

  it "should inser the products for the liquidation" do
    3.times { FactoryGirl.create(:subcategory_name) }
    lps = LiquidationProductsService.new(liquidation.id)
    expect {
      lps.add Product.all.map(&:id).join(","), 30.2
    }.to change(LiquidationProduct, :count).by(3)
    LiquidationProduct.last.subcategory_name.should == "Sandalia"
      #t.references :liquidation
      #t.references :product
      #t.integer :category_id
      #t.string :subcategory_name
      #t.decimal :original_price, :precision => 10, :scale => 2
      #t.decimal :retail_price, :precision => 10, :scale => 2
      #t.float :discount_percent
      #t.integer :shoe_size
      #t.float :heel
  end
end
