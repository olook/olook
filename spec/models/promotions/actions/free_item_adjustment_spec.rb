# -*- encoding : utf-8 -*-
require 'spec_helper'

describe FreeItemAdjustment do
  let!(:cart) { FactoryGirl.create(:cart_with_3_items) }

  describe "#simulate" do
    context "when cart has items" do
      it "returns price of item with lower price" do
        subject.simulate(cart).should eq(cart.items.first.price)
      end
    end

    context "when cart has no items" do
      it "returns zero" do
        cart.items.should_receive(:any?).and_return(0)
        subject.simulate(cart).should eq(0)
      end
    end
  end

  describe "#apply" do
    it "set retail price as zero" do
      cart.items.first.cart_item_adjustment.should_receive(:update_attributes)
      subject.apply(cart)
      cart.items.first.price.should eq(0)
    end
  end

end
