# -*- encoding : utf-8 -*-
class CouponManager
  attr_accessor :order, :coupon

  def initialize(order, code = nil)
    @order, @coupon = order, Coupon.find_by_code(code)
  end

  def apply_coupon
    if coupon.try(:expired?)
      msg = "Cupom expirado. Informe outro por favor"
    elsif coupon.try(:available?)
      if order.used_coupon
        order.used_coupon.update_attributes(:coupon => coupon)
      else
        order.create_used_coupon(:coupon => coupon)
      end
      msg = "Cupom atualizado com sucesso"
    else
      order.used_coupon.try(:destroy)
      msg = "Cupom não existente"
    end
  end

  def remove_coupon
    order.used_coupon.try(:destroy)
  end
end
