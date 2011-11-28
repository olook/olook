class Cart
  attr_reader :order, :freight
  def initialize(order, freight = nil)
    @order, @freight = order, freight
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
   freight ? freight[:price] : 0
  end
end
