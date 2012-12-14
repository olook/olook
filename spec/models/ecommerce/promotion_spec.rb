require 'spec_helper'

describe Promotion do
  describe "strategies" do
    it "should apply the appropriated strategy" do
      promo = FactoryGirl.create(:first_time_buyers)
      promo.load_strategy.should  eq(Promotions::PurchasesAmountStrategy)
    end
  end
end
