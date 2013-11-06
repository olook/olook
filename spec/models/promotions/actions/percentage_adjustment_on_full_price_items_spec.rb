# -*- encoding : utf-8 -*-
require 'spec_helper'

describe PercentageAdjustmentOnFullPriceItems do
  let(:cart) { FactoryGirl.create(:cart_with_1_full_and_1_discount) }
  describe "#calculate_cart_item" do
    before do
      @cart_item = cart.items.last
    end
    it "returns hash with adjust for markdown product" do
      @cart_item.should_receive(:price).and_return(BigDecimal("100.0"))
      expect(subject.calculate_cart_item(@cart_item, '30')).to include({id: @cart_item.id, adjustment: BigDecimal("30.0")})
    end
  end
  describe "#calculate" do
    it "return empty array if dont have item with full price" do
      cart.items.each do |item|
        item.should_receive(:promotion?).and_return(true)
      end
      expect(subject.calculate(cart.items,"30")).to be_empty
    end
    it "return array with adjustment if we have item with full price and with olook brand" do
      cart.items.each do |item|
        item.should_receive(:promotion?).and_return(false)
        item.should_receive(:accepted_brands).and_return(true)
      end
      expect(subject.calculate(cart.items,"30").size).to eql(2)
    end
  end
end
