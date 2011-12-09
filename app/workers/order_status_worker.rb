# -*- encoding : utf-8 -*-
class OrderStatusWorker
  @queue = :order_status

  def self.perform(order_id)
    order = Order.find(order_id)

    if order.waiting_payment?
      mail = OrderStatusMailer.order_requested(order)
    elsif order.completed?
      mail = OrderStatusMailer.payment_confirmed(order)
    end
    mail.deliver
  end
end
