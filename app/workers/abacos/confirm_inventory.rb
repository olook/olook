# -*- encoding : utf-8 -*-
module Abacos
  class ConfirmInventory
    @queue = :inventory_acknowledgment

    def self.perform(protocol)
      Abacos::ProductAPI.confirm_inventory protocol
    end
  end
end
