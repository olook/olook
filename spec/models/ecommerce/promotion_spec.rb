require 'spec_helper'

describe Promotion do
  describe "strategies" do
    it "should load the apropriated strategy" do
      promo = FactoryGirl.create(:first_time_buyers)
      promo.load_strategy.should be_a(Promotions::PurchasesAmountStrategy)
    end
  end
end
