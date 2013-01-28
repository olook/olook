# -*- encoding : utf-8 -*-
require 'spec_helper'

describe CartItemsTotalValue do
  describe "#matches" do
    let(:cart) { FactoryGirl.create(:cart_with_items) }

    it { should respond_to(:matches?).with(2).argument }

    before :each do
      cart.items.first.stub(:quantity).and_return(1)
      cart.items.first.stub(:price).and_return(BigDecimal("100"))
    end

    context "when items total value is lower than parameter" do
      it "returns false" do
        subject.matches?(cart, BigDecimal("120")).should be_false
      end
    end

    context "when items total value is greater than parameter" do
      it "returns true" do
        subject.matches?(cart, BigDecimal("50")).should be_true
      end
    end

    context "when items total value is equal than parameter" do
      it "returns true" do
        subject.matches?(cart, BigDecimal("100")).should be_true
      end
    end

  end
end
