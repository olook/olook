# -*- encoding : utf-8 -*-
module Abacos
  class ConfirmPayment
    @queue = :front_to_abacos

    def self.perform(order_number)
      raise "Order number #{order_number} doesn't exist on Abacos" unless Abacos::OrderAPI.order_exists?(order_number)

      order = Order.find_by_number order_number
      create_order_event order
      confirmar_pagamento = Abacos::ConfirmarPagamento.new order
      Abacos::OrderAPI.confirm_payment confirmar_pagamento
    end

    def self.create_order_event(order)
      order.order_events.create(:message => "Calling Abacos::ConfirmPayment")
    end
  end
end
