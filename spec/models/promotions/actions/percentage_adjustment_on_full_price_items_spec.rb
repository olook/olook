# -*- encoding : utf-8 -*-
require 'spec_helper'

describe PercentageAdjustmentOnFullPriceItems do
  let(:subject) { FactoryGirl.create(:percentage_adjustment) }
  let(:cart) { FactoryGirl.create(:cart_with_1_full_and_1_discount) }
  describe "#apply" do
    let(:promo) { mock_model(Promotion) }
    let(:action_parameter) { mock_model(ActionParameter, param: "0.2") }
    it "cart item returns price without markdown" do
      promo.should_receive(:action_parameter).at_least(1).times.and_return(action_parameter)
      subject.apply(cart, promo.action_parameter.action_params, promo)
      cart.items.last.adjustment_value.should eq(cart.items.first.price * promo.action_parameter.param.to_d)
    end
    it "cart item returns price with markdown" do
      promo.should_receive(:action_parameter).at_least(1).times.and_return(action_parameter)
      cart.items.first.product.should_receive(:price).and_return(100.0)
      cart.items.first.product.should_receive(:retail_price).and_return(100.0)
      cart.items.last.product.should_receive(:price).and_return(100.0)
      cart.items.last.product.should_receive(:retail_price).and_return(70.0)
      subject.apply(cart, promo.action_parameter.action_params, promo)
      cart.items.first.adjustment_value.should eq(cart.items.first.price * promo.action_parameter.param.to_d)
    end
  end  
end
