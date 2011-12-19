require 'spec_helper'

describe LineItem do
  it {should validate_presence_of(:order_id) }
  it {should validate_presence_of(:variant_id) }
  it {should validate_presence_of(:quantity) }

  it "should return the total_price" do
    quantity = 2
    variant = FactoryGirl.create(:basic_shoe_size_35)
    line_item = FactoryGirl.create(:line_item, :variant => variant, :quantity => quantity, :price => variant.price)
    line_item.total_price.should == variant.price * quantity
  end
end
