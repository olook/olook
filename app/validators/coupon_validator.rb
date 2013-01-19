# -*- encoding : utf-8 -*-
class CouponValidator < ActiveModel::Validator
  def validate(record)
    if record.coupon_code && !record.coupon_code.empty?
      coupon = Coupon.find_by_code(record.coupon_code)
      if coupon.try(:expired?)
        record.errors.add(:coupon_code, "Cupom expirado. Informe outro por favor")
      elsif !coupon.try(:available?)
        record.errors.add(:coupon_code, "Cupom inválido")
      end
    end
  end
end