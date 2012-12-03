require 'spec_helper'

describe Promotion do
  describe "strategies" do
    it "should apply the appropriated strategy" do
      promo = FactoryGirl.create(:first_time_buyers)
      promo.load_strategy.to_s.should  == "Promotions::PurchasesAmountStrategy"
    end
  end
end
