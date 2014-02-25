# -*- encoding : utf-8 -*-
class UniqueCouponUtilizationPolicy

  def self.apply? opt
    coupon = opt[:coupon]
    user_coupon = opt[:user_coupon]
    if user_coupon && coupon
      coupon.one_per_user? && !user_coupon.include?(coupon.id)
    else
      true
    end
  end

end