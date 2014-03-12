# -*- encoding : utf-8 -*-
class UniqueCouponUtilizationPolicy

  def self.apply? opt
    coupon = opt[:coupon]
    user_coupon = opt[:user_coupon]
    return true if not coupon.try(:one_per_user?)
    if user_coupon && coupon
      !user_coupon.include?(coupon.id)
    else
      true
    end
  end

end
