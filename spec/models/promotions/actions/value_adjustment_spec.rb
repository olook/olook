# -*- encoding : utf-8 -*-
require 'spec_helper'

describe ValueAdjustment do
  describe "#simulate" do
    let(:cart) { FactoryGirl.create(:cart_with_items) }
     it "returns hash with cart items and discounts" do
        cart.items.should_receive(:size).and_return(2)
        subject.simulate(cart, BigDecimal("20")).should eq(BigDecimal("10"))
     end
  end
end
