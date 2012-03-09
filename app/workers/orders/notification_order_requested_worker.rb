# -*- encoding : utf-8 -*-
module Orders
  class NotificationOrderRequestedWorker
    @queue = :order_status

    def self.perform(order_id)
      order = Order.find(order_id)
      send_email(order)
    end

    def self.send_email(order)
      if order.waiting_payment?
        mail = OrderStatusMailer.order_requested(order)
        mail.deliver
      end
    end
  end
end
