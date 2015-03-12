# -*- encoding : utf-8 -*-
module Abacos
  class CancelOrder
    @queue = 'urgent'

    def self.perform(order_number)
      order = Order.find_by_number order_number    
      
      order.canceled if should_cancel? order

      if order.canceled? && Abacos::OrderAPI.order_exists?(order_number)
        cancelar_pedido = Abacos::CancelarPedido.new order
        begin
          Abacos::OrderAPI.cancel_order cancelar_pedido
        rescue Exception => error
          Airbrake.notify(error)
        end
      end
    end

    private

      def self.should_cancel? order
        (order.can_be_canceled? && !order.payment_rollback?)
      end
  end
end
