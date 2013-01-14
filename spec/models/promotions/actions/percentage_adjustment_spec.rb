# -*- encoding : utf-8 -*-
require 'spec_helper'

describe PercentageAdjustment do
  let(:subject) { FactoryGirl.create(:percentage_adjustment) }
  let(:cart) { FactoryGirl.create(:cart_with_items) }
  describe "#apply" do
    let(:promo) { mock_model(Promotion) }
    let(:action_parameter) { mock_model(ActionParameter, param: "0.2") }

    context "when adjust should be changed" do
      it "cart item returns calculated adjustment value" do
        promo.should_receive(:action_parameter).at_least(2).times.and_return(action_parameter)
        subject.apply(cart, promo.action_parameter.action_params)
        cart.items.first.adjustment_value.should eq(cart.items.first.price * promo.action_parameter.param.to_d)
      end
    end
  end

  describe "#simulate" do
    context "when cart has items" do
      it "calculates percentage" do
        subject.simulate(cart, "20").should eq([{id: cart.items.first.id, adjust: cart.items.first.price * BigDecimal("#{20 / 100.0}")}])
      end
    end

    context "when cart has no items" do
      it "returns zero" do
        cart.should_receive(:items).and_return([])
        subject.simulate(cart,"20").should eq(0)
      end
    end
  end
end


