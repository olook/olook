# -*- encoding : utf-8 -*-
module Orders
  class NotificationPaymentConfirmedWorker
    @queue = :order_status

    def self.perform(order_id)
      order = Order.find(order_id)
      send_email(order)
    end

    def self.send_email(order)
      if order.authorized?
        mail = OrderStatusMailer.payment_confirmed(order)
        #mail.deliver
      end
    end
  end
end
