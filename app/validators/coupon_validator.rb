# -*- encoding : utf-8 -*-
class CouponValidator < ActiveModel::Validator
  def validate(record)
    if record.coupon_code.present?
      coupon = Coupon.find_by_code(record.coupon_code)
      case
        when coupon.try(:expired?)
          record.errors.add(:coupon_code, "O cupom informado já está expirado. Se você possui outro, informe abaixo.")
        when !coupon.try(:available?)
          record.errors.add(:coupon_code, "O cupom informado não é válido. Por favor, verifique o código informado.")
        when !coupon.try(:can_be_applied_to_any_product_in_the_cart?, record)
          record.errors.add(:coupon_code, "O cupom informado é válido apenas para produtos da marca #{ coupon.try(:brand)}. Navegue em nosso site e escolha outras peças desta marca. ;)")
      end
    end
  end
end
