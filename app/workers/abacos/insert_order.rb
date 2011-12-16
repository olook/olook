# -*- encoding : utf-8 -*-
module Abacos
  class InsertOrder
    @queue = :orders_and_inventory

    def self.perform(order_number)
      order = parse_and_check_order order_number
      insert_order(order) if export_client(order)
    end
  private
    def self.parse_and_check_order(order_number)
      order = Order.find_by_number order_number
      raise "Order number #{order_number} doesn't have an associated payment" unless order.payment
      raise "Order number #{order_number} already exist on Abacos" if Abacos::OrderAPI.order_exists?(order_number)
      order
    end
    
    def self.export_client(order)
      cliente = Abacos::Cliente.new order.user, order.freight.address
      Abacos::ClientAPI.export_client cliente
    end
    
    def self.insert_order(order)
      pedido = Abacos::Pedido.new order
      Abacos::OrderAPI.insert_order pedido
    end
  end
end
