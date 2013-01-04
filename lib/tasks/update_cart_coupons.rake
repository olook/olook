# -*- encoding : utf-8 -*-
namespace :db do

  desc "Updates cart coupon with order coupon, when it exists"
  task :update_cart_coupons => :environment do
    Payment.where(:type => "CouponPayment").find_each do |pmt|
      pmt.order.cart.update_attribute(:coupon, pmt.coupon) if pmt.order && pmt.order.cart
    end
  end
end