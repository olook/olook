require 'spec_helper'

describe Promotions::PurchasesAmountStrategy do
  let(:promo) {FactoryGirl.create(:first_time_buyers)}
  let(:user_with_order_delivered) {FactoryGirl.create(:delivered_order).user}
  let(:order) {user_with_order_delivered.orders.first}
  it "should be applied if the user matches the requirement" do
    Promotions::PurchasesAmountStrategy.new(promo.param, FactoryGirl.create(:user)).matches?.should be_true
  end

  it "should not be applied if the user matches the requirement" do
    Promotions::PurchasesAmountStrategy.new(promo.param, user_with_order_delivered ).matches?.should be_false
  end

  it "should return true if is first buy and used promotion" do
    order.payments << FactoryGirl.create(:payment, promotion_id: 1)
    Promotions::PurchasesAmountStrategy.new("1", user_with_order_delivered, order).matches_20_percent_promotion?.should be_true
  end

end
