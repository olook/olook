# -*- encoding : utf-8 -*-
module Abacos
  class ConfirmPayment
    @queue = 'medium'

    def self.perform(order_number)
      return true unless Setting.abacos_integrate

      order = Order.find_by_number order_number
      unless Abacos::OrderAPI.order_exists?(order_number)
        Abacos::InsertOrder.perform order.number
        sleep 15
      end
      confirmar_pagamento = Abacos::ConfirmarPagamento.new order
      Abacos::OrderAPI.confirm_payment confirmar_pagamento
    end
  end
end



