# -*- encoding : utf-8 -*-
class OrderObserver < ActiveRecord::Observer
  def after_save(order)
    Resque.enqueue(OrderStatusWorker, order.id) if order.payment
  end
end

