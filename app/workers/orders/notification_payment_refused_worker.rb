# -*- encoding : utf-8 -*-
module Orders
  class NotificationPaymentRefusedWorker
    @queue = :order_status

    def self.perform(order_id)
      order = Order.find(order_id)
      send_email(order)
    end

    def self.send_email(order)
      if order.canceled? || order.reversed?
        if order.payment.credit_card?
          mail = OrderStatusMailer.payment_refused(order)
          mail.deliver
        end
      end
    end
  end
end
