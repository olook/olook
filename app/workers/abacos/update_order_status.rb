# -*- encoding : utf-8 -*-
module Abacos
  class UpdateOrderStatus
    @queue = :orders_and_inventory

    def self.perform
      Abacos::OrderAPI.download_orders_statuses.each do |abacos_order_status|
        parsed_data = Abacos::OrderStatus.parse_abacos_data(abacos_order_status)
        Resque.enqueue(Abacos::Integrate, Abacos::OrderStatus.to_s, parsed_data)
      end
    end
  end
end
