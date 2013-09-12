# -*- encoding : utf-8 -*-
class CouponValidator < ActiveModel::Validator
  def validate(record)
    if record.coupon_code.present?
      coupon = Coupon.find_by_code(record.coupon_code)
      case
        when coupon.try(:expired?)
          record.errors.add(:coupon_code, "Cupom expirado. Informe outro por favor")
        when !coupon.try(:available?)
          record.errors.add(:coupon_code, "Cupom inválido")
        when !coupon.try(:is_more_advantageous_than_any_promotion?, record)
          record.errors.add(:coupon_code, "A promoção é mais vantajosa que o cupom")
        when !coupon.try(:can_be_applied_to_any_product_in_the_cart?, record)
          record.errors.add(:coupon_code, "Não pode ser aplicado")
      end
    end
  end
end
