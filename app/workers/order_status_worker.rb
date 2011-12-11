# -*- encoding : utf-8 -*-
class OrderStatusWorker
  @queue = :order_status

  def self.perform(order_id)
    order = Order.find(order_id)

    if order.waiting_payment?
      mail = OrderStatusMailer.order_requested(order)
    elsif order.authorized?
      mail = OrderStatusMailer.payment_confirmed(order)
    elsif order.canceled? || order.reversed?
      mail = OrderStatusMailer.payment_refused(order)
    elsif order.delivered?
      mail = OrderStatusMailer.order_delivered(order)
    end
    mail.deliver if mail
  end
end
