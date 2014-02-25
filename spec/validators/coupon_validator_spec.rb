# -*- encoding : utf-8 -*-
require 'spec_helper'

describe CouponValidator do

  let(:cart) { FactoryGirl.build(:clean_cart) }
  subject { described_class.new({}) }

  describe "#validate" do

    context "coupon_code doesnt exist" do
      it "doesnt add any error to record when coupon_code is nil" do
        cart.coupon_code = nil
        subject.validate(cart)
        cart.errors.size.should eq(0)
      end

      it "doesnt add any error to record when coupon_code is empty" do
        cart.coupon_code = ""
        subject.validate(cart)
        cart.errors.size.should eq(0)
      end
    end

    context "coupon_code exists" do

      context "and coupon is expired" do
        let(:expired_coupon) { FactoryGirl.build(:expired_coupon) }

        it "adds an error" do
          cart.coupon_code = expired_coupon.code
          Coupon.stub(:find_by_code).with(expired_coupon.code).and_return(expired_coupon)
          subject.validate(cart)
          cart.errors.size.should eq(1)
        end

        it "associates an error to coupon_code" do
          cart.coupon_code = expired_coupon.code
          Coupon.stub(:find_by_code).with(expired_coupon.code).and_return(expired_coupon)
          subject.validate(cart)
          cart.errors[:coupon_code].first.should eq("Este cupom não é mais válido :/")
        end
      end

      context "and coupon is not found" do
        it "adds an error" do
          cart.coupon_code = "CODE"
          Coupon.stub(:find_by_code).with(cart.coupon_code).and_return(nil)
          subject.validate(cart)
          cart.errors.size.should eq(1)
        end

        it "associates an error to coupon_code" do
          cart.coupon_code = "CODE"
          Coupon.stub(:find_by_code).with(cart.coupon_code).and_return(nil)
          subject.validate(cart)
          cart.errors[:coupon_code].first.should eq("Cupom inexistente. Tente digitar novamente.")
        end
      end

      context "and coupon is not available" do
        let(:unavailable_coupon) { FactoryGirl.build(:unavailable_coupon) }

        it "adds an error" do
          cart.coupon_code = unavailable_coupon.code
          Coupon.stub(:find_by_code).with(cart.coupon_code).and_return(unavailable_coupon)
          subject.validate(cart)
          cart.errors.size.should eq(1)
        end

        it "associates an error to coupon_code" do
          cart.coupon_code = unavailable_coupon.code
          Coupon.stub(:find_by_code).with(cart.coupon_code).and_return(unavailable_coupon)
          subject.validate(cart)
          cart.errors[:coupon_code].first.should eq("Este cupom não é mais válido :/")
        end
      end

      context "and coupon is available" do
        let(:available_coupon) { FactoryGirl.build(:coupon) }

        it "doesnt add an error to cart" do
          cart.coupon_code = available_coupon.code
          Coupon.stub(:find_by_code).with(cart.coupon_code).and_return(available_coupon)
          subject.validate(cart)
          cart.errors.size.should eq(0)
        end

      end
    end
  end

end
