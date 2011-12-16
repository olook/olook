# -*- encoding : utf-8 -*-
module Abacos
  class ConfirmInventory
    @queue = :orders_and_inventory

    def self.perform(protocol)
      Abacos::ProductAPI.confirm_inventory protocol
    end
  end
end
