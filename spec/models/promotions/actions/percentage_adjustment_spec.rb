# -*- encoding : utf-8 -*-
require 'spec_helper'

describe PercentageAdjustment do
  describe "#calculate" do
    context "when adjust should be changed" do
      it "cart item returns calculated adjustment value" do
        cart_item = double('cart_item')
        cart_item.stub(id: 7, product: stub(id: 77), quantity: 1, price: 100)
        subject.calculate([cart_item], { 'param' => '10' }).should eq([{id: 7, product_id: 77, adjustment: 10}])
      end
    end
  end
end


