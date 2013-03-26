# -*- encoding : utf-8 -*-
require 'spec_helper'

describe SpecificCategory do
  describe "#matches?" do
    let(:cart) { FactoryGirl.create(:cart_with_items) }

    context "when cart has some item of specific category" do
      it "matches" do
        subject.matches?(cart, "sapato").should be_true
      end
    end

    context "category name is upcase" do
      it "matches" do
        subject.matches?(cart, "SApato").should be_true
      end
    end

    context "when cart has no item of specific category" do
      it "doesn't matches" do
        subject.matches?(cart, "bolsa").should be_false
      end
    end

    context "when cart has no items" do
      it "doesn't matches" do
        cart.should_receive(:items).and_return([])
        subject.matches?(cart, "sapato").should be_false
      end
    end

    context "when there's no rule parameter" do
      it "doesn't matches" do
        subject.matches?(cart).should be_false
      end
    end

  end
end
