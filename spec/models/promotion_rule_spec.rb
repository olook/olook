# -*- encoding : utf-8 -*-
require 'spec_helper'

describe PromotionRule do

  describe "validations" do
    it { should validate_presence_of :type }
    it { should have_many :rule_parameters }
  end

  describe "#matches?" do
    it { should respond_to(:matches?).with(2).arguments }
  end
end
