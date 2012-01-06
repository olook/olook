# -*- encoding : utf-8 -*-
require "spec_helper"

describe CouponManager do
  let(:order) { FactoryGirl.create(:order) }
  let(:standard_coupon) { FactoryGirl.create(:standard_coupon) }
  let(:expired_coupon) { FactoryGirl.create(:expired_coupon) }
  subject { CouponManager.new(order, standard_coupon.code) }

  context "with a valid coupon" do
    it "should create a used coupon" do
      expect {
        subject.apply_coupon
      }.to change(UsedCoupon, :count).by(1)
    end

    context "when already exists a used coupon" do
      before :each do
        order.create_used_coupon(:coupon => standard_coupon)
      end

      it "should not create used coupon when alread exists one" do
        expect {
          subject.apply_coupon
        }.to change(UsedCoupon, :count).by(0)
      end

      it "should update the used coupon" do
        order.used_coupon.should_receive(:update_attributes).with(:coupon => standard_coupon)
        subject.apply_coupon
      end
    end
  end

  context "with a invalid coupon" do
    it "should not create a used coupon" do
      coupon_manager = CouponManager.new(order, expired_coupon.code)
      expect {
        coupon_manager.apply_coupon
      }.to change(UsedCoupon, :count).by(0)
    end
  end
end
