# == Schema Information
#
# Table name: cart_items
#
#  id            :integer          not null, primary key
#  variant_id    :integer          not null
#  cart_id       :integer          not null
#  quantity      :integer          default(1), not null
#  gift_position :integer          default(0), not null
#  gift          :boolean          default(FALSE), not null
#

require 'spec_helper'

describe CartItem do
  it { should belong_to(:cart) }
  it { should belong_to(:variant) }

  describe "#product_quantity" do
    
    let(:cart_item) { FactoryGirl.create(:cart_item_that_belongs_to_a_cart) }

    context "for default product" do
      it "should return 1" do
        cart_item.product_quantity.should == [1]
      end
    end

    context "for suggested product" do
      it "should return an array from 1 to 5" do      
        cart_item.stub(:is_suggested_product?).and_return(true)
        cart_item.stub(:suggested_product_quantity).and_return([1,2,3,4,5])

        cart_item.product_quantity.should == [1,2,3,4,5]
      end
    end

  end
end
