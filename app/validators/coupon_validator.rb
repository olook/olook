# -*- encoding : utf-8 -*-
class CouponValidator < ActiveModel::Validator
  def validate(cart)
    if cart.coupon_code.present?
      coupon = Coupon.find_by_code(cart.coupon_code)
      if coupon.nil?
        cart.errors.add(:coupon_code, "Cupom inexistente. Tente digitar novamente.")
        return
      end
      if coupon.try(:expired?) || !coupon.try(:available?) || has_unique_coupon_restriction?(cart)
        cart.errors.add(:coupon_code, "Este cupom não é mais válido :/")
      end
    end
  end

  private
    def has_unique_coupon_restriction?(cart)
      return false if cart.user.nil?
      user_coupon = cart.user.user_coupon
      !UniqueCouponUtilizationPolicy.apply?(coupon: _coupon, user_coupon: user_coupon)
    end

end
