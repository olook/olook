# -*- encoding : utf-8 -*-
module Orders
  class NotificationOrderShippedWorker
    @queue = :order_status

    def self.perform(order_id)
      order = Order.find(order_id)
      send_email(order)
    end

    def self.send_email(order)
      if order.delivering?
        mail = OrderStatusMailer.order_shipped(order)
        #mail.deliver
      end
    end
  end
end
