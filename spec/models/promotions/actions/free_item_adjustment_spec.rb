# -*- encoding : utf-8 -*-
require 'spec_helper'

describe FreeItemAdjustment do
  describe "#simulate" do
    let(:cart) { mock_model Cart, items: [] }
    it "returns price of item with lower price" do
    i = 10
      3.times do
        item = mock_model CartItem, id: i, price: i
        cart.items << item
        i += 10
      end
      subject.simulate(cart).should eq(10)
    end
  end

  describe "#apply" do
    #subject
  end
end
