# -*- encoding : utf-8 -*-
module Abacos
  class ConfirmPayment
    @queue = :front_to_abacos

    def self.perform(order_number)
      order = Order.find_by_number order_number
      if Abacos::OrderAPI.order_exists?(order_number)
        create_confirm_order_event order
        confirmar_pagamento = Abacos::ConfirmarPagamento.new order
        Abacos::OrderAPI.confirm_payment confirmar_pagamento
      else
        create_enqueue_insert_order_event order
        Resque.enqueue(Abacos::InsertOrder, order.number)

        create_enqueue_confirm_order_event order
        Resque.enqueue_in_with_queue(:delayed_payment, 15.minutes, Abacos::ConfirmPayment, order.number)
        raise "Order number #{order_number} doesn't exist on Abacos"
      end
    end

    def self.create_enqueue_insert_order_event(order)
      order.order_events.create(:message => "Enqueue again Abacos::InsertOrder")
    end

    def self.create_confirm_order_event(order)
      order.order_events.create(:message => "Calling Abacos::ConfirmPayment")
    end

    def self.create_enqueue_confirm_order_event(order)
      order.order_events.create(:message => "Enqueue Abacos::ConfirmPayment")
    end
  end
end



