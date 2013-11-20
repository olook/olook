# -*- encoding : utf-8 -*-
require 'spec_helper'

describe SpecificItem do

  describe "#matches?" do
    let(:cart) { FactoryGirl.create(:cart_with_items) }
    it { should respond_to(:matches?).with(2).arguments }

    context "when product of item has promotion" do
      it "returns true" do

        product_id = cart.items.first.product.id
        subject.matches?(cart, "10,#{ product_id },13").should be_true
      end
    end

    context "when product of item has no promotion" do
      it "returns false" do
        subject.matches?(cart, "4, 5, 6").should be_false
      end
    end

    context "when cart has no items" do
      it "returns false" do
        cart.should_receive(:items).and_return([])
        subject.matches?(cart, "1, 2, 3").should be_false
      end
    end

  end
end

