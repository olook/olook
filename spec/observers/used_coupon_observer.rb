require 'spec_helper'

describe UsedCouponObserver do
  it "should remove an used promotion when a coupon is applied" do
    order = FactoryGirl.create(:order)
    order.create_used_promotion(:promotion => FactoryGirl.create(:first_time_buyers))
    expect {
      order.create_used_coupon(:coupon => FactoryGirl.create(:standard_coupon))
    }.to change(UsedPromotion, :count).from(1).to(0)
  end
end
