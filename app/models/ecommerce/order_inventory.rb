# -*- encoding : utf-8 -*-
class OrderInventory
  attr_reader :order

  def initialize(order)
    @order = order
  end

  def rollback
    order.rollback_inventory
  end

  def should_rollback?
    order.canceled? || order.reversed? || order.refunded?
  end
end
