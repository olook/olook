require 'spec_helper'

describe LineItem do
  it {should validate_presence_of(:order_id) }
  it {should validate_presence_of(:variant_id) }
  it {should validate_presence_of(:quantity) }

  before :each do
    @quantity = 2
    @variant = FactoryGirl.create(:basic_shoe_size_35)
    @line_item = FactoryGirl.create(:line_item, :variant => @variant, :quantity => @quantity, :price => @variant.price)
    @normal_price = @line_item.price
  end

  it "should return the total_price" do
    @line_item.total_price.should == @variant.price * @quantity
  end

  it "should return the normal price" do
    @line_item.price.should == @normal_price
  end
end
