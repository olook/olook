# -*- encoding : utf-8 -*-
module Abacos
  class ConfirmInventory
    @queue = 'medium'

    def self.perform(protocol)
      Abacos::ProductAPI.confirm_inventory protocol
    end
  end
end
