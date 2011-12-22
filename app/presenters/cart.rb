# -*- encoding : utf-8 -*-
class Cart
  attr_reader :order

  def initialize(order)
    @order = order
  end

  def total
    order.total_with_freight
  end

  def subtotal
    order.total + credits_discount + gift_discount
  end

  def credits_discount
    order.credits || 0
  end

  def gift_discount
    order.discount_from_gift
  end

  def freight_price
   order.freight ? order.freight_price : 0
  end
end
