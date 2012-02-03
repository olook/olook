class UsedCouponObserver < ActiveRecord::Observer
  def after_create(used_coupon)
    order = used_coupon.order
    order.used_promotion.destroy if order.used_promotion
  end
end
