require 'spec_helper'

describe CartItem do
  it { should belong_to(:cart) }
  it { should belong_to(:variant) }
  let(:cart_item) { FactoryGirl.create(:cart_item_that_belongs_to_a_cart) }

  describe "#product_quantity" do
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

  describe "#adjusted_price" do
    let(:adjustment) { FactoryGirl.create(:cart_item_adjustment, cart_item: cart_item) }

    context "cart_item with adjustment" do
      it "returns value calculated" do
        cart_item.stub(:adjustment).and_return(adjustment)
        cart_item.stub(:price).and_return(BigDecimal("59.99"))
        cart_item.adjusted_price.to_s.should eq("50.0")
      end

      it "returns full price" do
        cart_item.adjusted_price.should eq(cart_item.price)
      end

    end
  end
end
