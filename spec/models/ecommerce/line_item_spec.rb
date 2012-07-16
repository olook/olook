require 'spec_helper'

describe LineItem do
  it {should validate_presence_of(:order_id) }
  it {should validate_presence_of(:variant_id) }
  it {should validate_presence_of(:quantity) }

  before :each do
    @quantity = 2
    @variant = FactoryGirl.create(:basic_shoe_size_35)
    @line_item = FactoryGirl.create(:line_item, :variant => @variant, :quantity => @quantity, :price => @variant.price, :retail_price => @variant.retail_price)
    @normal_price = @line_item.price
  end

  it "should return the total_price" do
    @line_item.total_price.should == @variant.retail_price * @quantity
  end

  it "should return the normal price" do
    @line_item.price.should == @normal_price
  end

  it "should delegate liquidation to variant" do
    @variant.stub(:liquidation?).and_return(true)
    @line_item.liquidation?.should be_true
  end
end
