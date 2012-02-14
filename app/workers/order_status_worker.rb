# -*- encoding : utf-8 -*-
class OrderStatusWorker
  @queue = :order_status

  def self.perform(order_id)
    order = Order.find(order_id)
    base_date = Date.civil(2012, 2, 13)
    send_email(order) if Date.current > base_date
  end

  def self.send_email(order)
    if order.waiting_payment?
      mail = OrderStatusMailer.order_requested(order)
    elsif order.authorized?
      mail = OrderStatusMailer.payment_confirmed(order)
    elsif order.delivering?
      mail = OrderStatusMailer.order_shipped(order)
    elsif order.delivered?
      mail = OrderStatusMailer.order_delivered(order)
    elsif order.canceled? || order.reversed?
      if order.payment.credit_card?
        mail = OrderStatusMailer.payment_refused(order)
      end
    end
    mail.deliver if mail
  end
end
