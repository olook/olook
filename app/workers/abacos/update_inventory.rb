# -*- encoding : utf-8 -*-
module Abacos
  class UpdateInventory
    @queue = :abacos_to_front

    def self.perform
      process_inventory
    end

  private

    def self.process_inventory
      ProductAPI.download_inventory.each do |abacos_inventory|
        parsed_data = Abacos::Inventory.parse_abacos_data(abacos_inventory)
        Resque.enqueue(Abacos::Integrate, Abacos::Inventory.to_s, parsed_data)
      end
    end
  end
end
