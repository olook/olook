# -*- encoding : utf-8 -*-
require 'spec_helper'

describe MinorPriceAdjustment do

  describe "#simulate" do
    it { should respond_to(:simulate).with(2).arguments }
  end

  describe "#calculate" do

    context "when cart_items is empty" do
      it "return 0" do
        subject.calculate([], {'param' => 1}).should == []
      end
    end

    context "when cart_items has 1 item with value = 75" do
      let(:cart_item) { mock(CartItem) }

      before do
        cart_item.stub(id: 1097, price: BigDecimal("75"), retail_price: BigDecimal("65"), product: stub(id: 7))
      end

      context "and quantity = 1" do

        it "return de item id and its value as adjustment" do
          cart_item.stub(quantity: 1)
          subject.calculate([cart_item], {'param' =>  1}).should == [{id: cart_item.id, product_id: 7, adjustment: BigDecimal("75")}]
        end
      end

      context "and quantity = 2" do

        it "return de item id and its value as adjustment" do
          cart_item.stub(quantity: 2)
          subject.calculate([cart_item], {'param' => 1}).should == [{id: cart_item.id, product_id: 7, adjustment: BigDecimal("75")}]
        end
      end
    end

    context "when cart_items has 3 items with value = 75, 85, 100" do
      let(:cart_item_1) { mock(CartItem) }
      let(:cart_item_2) { mock(CartItem) }
      let(:cart_item_3) { mock(CartItem) }
      let(:cart_items) {[cart_item_1, cart_item_2, cart_item_3]}

      before do
        cart_item_1.stub(id: 1001, price: BigDecimal("95"), retail_price: BigDecimal("85"), product: stub( id: 7))
        cart_item_2.stub(id: 1002, price: BigDecimal("50"), retail_price: BigDecimal("40"), product: stub( id: 8))
        cart_item_3.stub(id: 1003, price: BigDecimal("110"), retail_price: BigDecimal("90"), product: stub( id: 9))
      end

      context "when call calculate with quantity = 1" do
        before do
          @return = subject.calculate(cart_items, {'param' => 1})
        end

        it "return an array with 1 element" do
          @return.size.should == 1
        end

        it "return the minor item value (50)" do
          @return.should == [{id: cart_item_2.id, product_id: 8, adjustment: BigDecimal("50")}]
        end
      end

      context "when call calculate with quantity = 2" do
        before do
          @return = subject.calculate(cart_items, {'param' => 2})
        end

        it "return an array with 2 elements" do
          @return.size.should == 2
        end

        it "return 2 minor item values (50, 95)" do
          @return.should == [{id: cart_item_2.id, product_id: 8, adjustment: BigDecimal("50")}, {id: cart_item_1.id, product_id: 7, adjustment: BigDecimal("95")}]
        end
      end

    end

  end
end
