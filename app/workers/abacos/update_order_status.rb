# -*- encoding : utf-8 -*-
module Abacos
  class UpdateOrderStatus
    @queue = :order_status

    def self.perform
      return true unless Setting.abacos_integrate

      # Tive que alterar para o modo sequencial pq nao estava atualizanodo o status e eu nao 
      # consegui identificar o porque.      
      Abacos::OrderAPI.download_orders_statuses.each do |abacos_order_status|
        begin
          parsed_data = Abacos::OrderStatus.parse_abacos_data(abacos_order_status)
          Abacos::OrderStatus.new(parsed_data).integrate
        rescue => e
          Rails.logger.error("Erro ao atualizar o status do pedido, number=#{parsed_data[:numero_pedido]}: #{e}")
        end
      end
    end
  end
end
