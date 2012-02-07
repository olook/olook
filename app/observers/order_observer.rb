# -*- encoding : utf-8 -*-
class OrderObserver < ActiveRecord::Observer
  def after_save(order)
    if order.state == "authorized"
      coupon = Coupon.lock("LOCK IN SHARE MODE").find_by_id(order.used_coupon.try(:coupon_id))
      if coupon
        coupon.decrement!(:remaining_amount, 1) unless coupon.unlimited?
        coupon.increment!(:used_amount, 1)
      end
    end
    order_inventory = OrderInventory.new(order)
    order_inventory.rollback if order_inventory.available_for_rollback?
    Resque.enqueue(OrderStatusWorker, order.id) if order.payment
  end
end