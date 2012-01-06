# -*- encoding : utf-8 -*-
class UsedCoupon < ActiveRecord::Base
  belongs_to :order
  belongs_to :coupon
  delegate :value, :to => :coupon, :allow_nil => true
  delegate :code, :to => :coupon, :allow_nil => true
end
