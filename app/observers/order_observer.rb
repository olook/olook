# -*- encoding : utf-8 -*-
class OrderObserver < ActiveRecord::Observer
  def after_create(order)
    Resque.enqueue(Abacos::UpdateInventory)
  end

  def after_save(order)
    order.use_coupon if order.authorized?
    Resque.enqueue(OrderStatusWorker, order.id) if order.payment
  end
end
