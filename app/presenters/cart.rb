# -*- encoding : utf-8 -*-
class Cart
  attr_reader :order

  def initialize(order)
    @order = order
  end

  def total
    order.total
  end

  def subtotal
    order.total + discount
  end

  def discount
    order.credits || 0
  end

  def freight_price
   order.freight ? order.freight_price : 0
  end
end
