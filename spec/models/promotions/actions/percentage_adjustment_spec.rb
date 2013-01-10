# -*- encoding : utf-8 -*-
require 'spec_helper'

describe PercentageAdjustment do
  describe "#apply" do
    let(:cart) { FactoryGirl.create(:cart_with_items) }
    let(:promo) { mock_model(Promotion) }
    let(:action_parameter) { mock_model(ActionParameter, param: "0.2") }
    let(:subject) { FactoryGirl.create(:percentage_adjustment) }

    context "when adjust should be changed" do
      it "cart item returns calculated adjustment value" do
        promo.should_receive(:action_parameter).at_least(2).times.and_return(action_parameter)
        subject.apply(cart, promo)
        cart.items.first.adjustment.value.should eq(cart.items.first.price * promo.action_parameter.param.to_d)
      end
    end

  end
end


