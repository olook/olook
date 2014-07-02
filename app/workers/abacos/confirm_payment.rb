# -*- encoding : utf-8 -*-
module Abacos
  class ConfirmPayment
    @queue = 'medium'

    def self.perform(order_number)
      return true unless Setting.abacos_integrate

      order = Order.find_by_number order_number
      if Abacos::OrderAPI.order_exists?(order_number)
        confirmar_pagamento = Abacos::ConfirmarPagamento.new order
        Abacos::OrderAPI.confirm_payment confirmar_pagamento
      else
        Resque.enqueue(Abacos::InsertOrder, order.number)
        Resque.enqueue_in_with_queue(:delayed_payment, 15.minutes, Abacos::ConfirmPayment, order.number)
      end
    end
  end
end



