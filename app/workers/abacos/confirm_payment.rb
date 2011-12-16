# -*- encoding : utf-8 -*-
module Abacos
  class ConfirmPayment
    @queue = :orders_and_inventory

    def self.perform(order_number)
      raise "Order number #{order_number} doesn't exist on Abacos" unless Abacos::OrderAPI.order_exists?(order_number)

      order = Order.find_by_number order_number
      confirmar_pagamento = Abacos::ConfirmarPagamento.new order
      Abacos::OrderAPI.confirm_payment confirmar_pagamento
    end
  end
end
