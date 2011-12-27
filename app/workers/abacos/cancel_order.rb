# -*- encoding : utf-8 -*-
module Abacos
  class CancelOrder
    @queue = :front_to_abacos

    def self.perform(order_number)
      raise "Order number #{order_number} doesn't exist on Abacos" unless Abacos::OrderAPI.order_exists?(order_number)

      order = Order.find_by_number order_number
      cancelar_pedido = Abacos::CancelarPedido.new order
      Abacos::OrderAPI.cancel_order cancelar_pedido
    end
  end
end
