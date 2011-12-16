# -*- encoding : utf-8 -*-
class OrderStatusWorker
  @queue = :order_status

  def self.perform(order_id)
    order = Order.find(order_id)
    send_email(order)
    integrate_with_abacos(order)
  end
  
  def self.send_email(order)
    if order.waiting_payment? && order.payment
      mail = OrderStatusMailer.order_requested(order)
    elsif order.authorized?
      mail = OrderStatusMailer.payment_confirmed(order)
    elsif order.canceled? || order.reversed?
      mail = OrderStatusMailer.payment_refused(order)
    elsif order.delivering?
      mail = OrderStatusMailer.delivering_order(order)
    end
    mail.deliver if mail
  end
  
  def self.integrate_with_abacos(order)
    if order.waiting_payment? && order.payment
      Resque.enqueue(Abacos::InsertOrder, order.number)
    elsif order.authorized?
      Resque.enqueue(Abacos::ConfirmPayment, order.number)
    end
  end  
end
