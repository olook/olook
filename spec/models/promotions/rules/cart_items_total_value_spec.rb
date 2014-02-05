# -*- encoding : utf-8 -*-
require 'spec_helper'

describe CartItemsTotalValue do
  describe "#matches" do
    let(:cart) { FactoryGirl.create(:cart_with_items) }

    before :each do
      cart.should_receive(:sub_total).and_return(BigDecimal("100"))
    end

    context "when items total value is lower than parameter" do
      it "returns false" do
        subject.matches?(cart, "120").should be_false
      end
    end

    context "when items total value is greater than parameter" do
      it "returns true" do
        subject.matches?(cart, "50").should be_true
      end
    end

    context "when items total value is equal than parameter" do
      it "returns true" do
        subject.matches?(cart, "100").should be_true
      end
    end

  end
end
