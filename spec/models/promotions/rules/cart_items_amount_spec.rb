# -*- encoding : utf-8 -*-
require 'spec_helper'

describe CartItemsAmount do

  describe "#matches" do
    let(:cart) { FactoryGirl.create(:cart_with_items) }

    it { should respond_to(:matches?).with(2).argument }

    context "when cart has item to give free" do
      it "returns true" do
        subject.matches?(cart, 2).should be_true
      end
    end

    context "when cart has item to give free" do
      it "returns true" do
        subject.matches?(cart, 3).should be_false
      end
    end

    context "when cart has the right amount of one item to give free" do

      before do
        cart_item = cart.items.first
        cart_item.stub(:quantity).and_return(3)
      end

      it "returns true" do
        subject.matches?(cart, 3).should be_true
      end
    end
  end


end
