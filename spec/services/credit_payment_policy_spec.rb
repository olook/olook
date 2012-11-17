require 'spec_helper'

describe CreditPaymentPolicy do
  
  context ".initialize" do
    it "should receive one parameter" do
      checker = CreditPaymentPolicy.new ([])
    end

    it "should throw exception for no parameters" do
      lambda {CreditPaymentPolicy.new}. should raise_error
    end
  end

  describe "#allow?" do
    let(:cart) { FactoryGirl.create(:cart_with_items) }
    let(:coupon_policy) { CreditPaymentPolicy.new cart }

    context "cart with 1 item without any discount" do
      it "should allow credit payment" do
        coupon_policy.allow?.should be_true
      end
    end

    context "cart with 1 item with olooklet discount" do
      it "should not allow credit payment" do

        cart.items.first.variant.product.price = 100
        cart.items.first.variant.product.retail_price = 70
        coupon_policy = CreditPaymentPolicy.new cart
        

        binding.pry

        coupon_policy.allow?.should be_false
      end
    end


  end

  context ".items_with_full_price" do
    let(:cart_item_with_full_price) {double(:item_price => 100, :item_retail_price => 100)}
    let(:cart_item_with_more_discount) {double(:item_price => 100, :item_retail_price => 80)}
    let(:cart_item_with_less_discount) {double(:item_price => 100, :item_retail_price => 90)}

    describe "2 items with discount and 1 item with full price" do

      let(:cart_items) {[cart_item_with_full_price, cart_item_with_less_discount, cart_item_with_more_discount]}

      it "should return the item with full price" do
        cart_items_checker = CreditPaymentPolicy.new cart_items
        cart_items_checker.items_with_full_price.should have(1).item
        cart_items_checker.items_with_full_price.should include(cart_item_with_full_price) 
      end
    end

    describe "2 items with discount and no item with full price" do

      let(:cart_items) {[cart_item_with_less_discount, cart_item_with_more_discount]}

      it "should return an empty array" do
        cart_items_checker = CreditPaymentPolicy.new cart_items
        cart_items_checker.items_with_full_price.should be_empty

      end
    end
  end

end