require 'spec_helper'

describe Promotions::PurchasesAmountStrategy do
  it "should be applied if the user matches the requirement" do
    promo = FactoryGirl.create(:first_time_buyers)
    Promotions::PurchasesAmountStrategy.new(promo.param, FactoryGirl.create(:user)).matches?.should be_true
  end

  it "should not be applied if the user matches the requirement" do
    promo = FactoryGirl.create(:first_time_buyers)
    Promotions::PurchasesAmountStrategy.new(promo.param, FactoryGirl.create(:order).user).matches?.should be_false
  end
end
