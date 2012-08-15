# -*- encoding : utf-8 -*-
module Abacos
  class UpdateOrderStatus
    @queue = :order_status

    def self.perform
      return true unless Setting.abacos_integrate
      
      Abacos::OrderAPI.download_orders_statuses.each do |abacos_order_status|
        parsed_data = Abacos::OrderStatus.parse_abacos_data(abacos_order_status)
        Resque.enqueue(Abacos::IntegrateOrderStatus, Abacos::OrderStatus.to_s, parsed_data)
      end
    end
  end
end
