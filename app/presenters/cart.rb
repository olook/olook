# -*- encoding : utf-8 -*-
class Cart
  attr_reader :order
  include ActionView::Helpers

  def initialize(order)
    @order = order
  end

  def total
    order.line_items.empty? ? 0 : order.total_with_freight
  end

  def subtotal
    order.line_items_total
  end

  def credits_discount
    order.credits || 0
  end

  def gift_discount
    order.discount_from_gift
  end

  def coupon_discount
    order.discount_from_coupon
  end

  def coupon_discount_in_percentage
    if order.used_coupon && order.used_coupon.is_percentage?
      percent = number_to_percentage((order.used_coupon.is_percentage? ? order.used_coupon.value : 0), :precision => 0)
      "(#{percent})"
    end
  end

  def freight_price
   order.freight ? order.freight_price : 0
  end
end
