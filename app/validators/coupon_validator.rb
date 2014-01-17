# -*- encoding : utf-8 -*-
class CouponValidator < ActiveModel::Validator
  def validate(cart)
    if cart.coupon_code.present?
      coupon = Coupon.find_by_code(cart.coupon_code)
      case
      when coupon.nil?
        cart.errors.add(:coupon_code, "Cupom inexistente. Tente digitar novamente.")
      when coupon.try(:expired?)
        cart.errors.add(:coupon_code, "Este cupom não é mais válido :/")
      else
        best_promotion = Promotion.select_promotion_for(cart)
        pd = ProductDiscountService.new(item.product, cart: cart, coupon: coupon, promotion: best_promotion)
        if pd.best_discount != coupon
          cart.errors.add(:coupon_code, "Os descontos não são cumulativos")
        end
      end
    end
  end
end
