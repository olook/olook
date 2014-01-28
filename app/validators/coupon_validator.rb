# -*- encoding : utf-8 -*-
class CouponValidator < ActiveModel::Validator
  def validate(cart)
    if cart.coupon_code.present?
      coupon = Coupon.find_by_code(cart.coupon_code)
      if coupon.nil?
        cart.errors.add(:coupon_code, "Cupom inexistente. Tente digitar novamente.")
        return
      end

      if coupon.try(:expired?) || !coupon.try(:available?)
        cart.errors.add(:coupon_code, "Este cupom não é mais válido :/")
      end
    end
  end
end
