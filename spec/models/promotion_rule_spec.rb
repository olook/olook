# -*- encoding : utf-8 -*-
require 'spec_helper'

describe PromotionRule do

  describe "validations" do
    it { should validate_presence_of :name }
    it { should validate_presence_of :type }
  end

  describe "#matches?" do
    it { should respond_to(:matches?).with(1).argument }
  end

  describe "#param_for" do
    let(:promotion_rule) { FactoryGirl.create(:promotion_rule) }

    it "returns param of promotion rule for than promotion" do
      promotion_rule.param_for(promotion_rule.promotions.first).should  eq(promotion_rule.rule_parameters.first.rules_params)
    end

  end

end
