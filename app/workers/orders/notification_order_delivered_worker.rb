# -*- encoding : utf-8 -*-
module Orders
  class NotificationOrderDeliveredWorker
    @queue = :order_status

    def self.perform(order_id)
      order = Order.find(order_id)
      send_email(order)
    end

    def self.send_email(order)
      if order.delivered?
        mail = OrderStatusMailer.order_delivered(order)
        mail.deliver
      end
    end
  end
end
