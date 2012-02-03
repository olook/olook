class UsedCouponObserver < ActiveRecord::Observer
  # if a coupon is applied to the order, them if a promotion is also applied it must be removed and the coupon must remain
  def after_save(used_coupon)
    order = used_coupon.order
    order.used_promotion.destroy if order.used_promotion
  end
end
