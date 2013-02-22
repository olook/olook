# -*- encoding : utf-8 -*-
module Abacos
  class CancelOrder
    @queue = :order

    def self.perform(order_number)
      order = Order.find_by_number order_number    
      
      order.canceled if should_cancel? order

      if order.canceled? && Abacos::OrderAPI.order_exists?(order_number)
        cancelar_pedido = Abacos::CancelarPedido.new order
        Abacos::OrderAPI.cancel_order cancelar_pedido
      end
    end

    private
      def self.should_cancel? order
        (order.can_be_canceled? && !order.payment_rollback?)
      end
  end


end
