require 'spec_helper'

describe Promotions::PurchasesAmountStrategy do
  it "should be applied if the user matches the requirement" do
    promo = FactoryGirl.create(:first_time_buyers)
    PromotionService.new(FactoryGirl.create(:user)).detect_current_promotion.id.should == promo.id
  end

  it "should not be applied if the user matches the requirement" do
    FactoryGirl.create(:first_time_buyers)
    PromotionService.new(FactoryGirl.create(:user)).detect_current_promotion.should == nil
  end
end
