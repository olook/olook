# -*- encoding : utf-8 -*-
require 'spec_helper'

describe PromotionRule do

  describe "validations" do
    it { should validate_presence_of :type }
    it { should have_many :rule_parameters }
    it { should have_many(:promotions).through(:rule_parameters) }
  end
end
