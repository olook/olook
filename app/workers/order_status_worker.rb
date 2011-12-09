# -*- encoding : utf-8 -*-
class OrderStatusWorker
  @queue = :order_status

  def self.perform(order_id)
    order = Order.find(order_id)

    mail = OrderStatusMailer.order_requested(order)
    mail.deliver
  end
end
