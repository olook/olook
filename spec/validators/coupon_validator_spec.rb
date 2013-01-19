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
        let(:coupon) { FactoryGirl.build(:expired_coupon) }

        it "adds an error" do
          cart.coupon_code = coupon.code
          Coupon.stub(:find_by_code).with(coupon.code).and_return(coupon)
          subject.validate(cart)
          cart.errors.size.should eq(1)
        end

        it "associates an error to coupon_code" do
          cart.coupon_code = coupon.code
          Coupon.stub(:find_by_code).with(coupon.code).and_return(coupon)
          subject.validate(cart)
          cart.errors[:coupon_code].first.should eq("Cupom expirado. Informe outro por favor")
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
          cart.errors[:coupon_code].first.should eq("Cupom inválido")
        end
      end

      context "and coupon is not available" do
        let(:coupon) { FactoryGirl.build(:not_available_coupon) }
        
        it "adds an error" do
          cart.coupon_code = coupon.code
          Coupon.stub(:find_by_code).with(cart.coupon_code).and_return(coupon)
          subject.validate(cart)
          cart.errors.size.should eq(1)
        end

        it "associates an error to coupon_code" do
          cart.coupon_code = coupon.code
          Coupon.stub(:find_by_code).with(cart.coupon_code).and_return(coupon)
          subject.validate(cart)
          cart.errors[:coupon_code].first.should eq("Cupom inválido")
        end
      end

      context "and coupon is available" do
        let(:coupon) { FactoryGirl.build(:coupon) }
        
        it "doesnt add an error to cart" do
          cart.coupon_code = coupon.code
          Coupon.stub(:find_by_code).with(cart.coupon_code).and_return(coupon)
          subject.validate(cart)
          cart.errors.size.should eq(0)
        end

      end
    end
  end

end