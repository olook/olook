# -*- encoding : utf-8 -*-
module Abacos
  class ConfirmProduct
    @queue = :product_acknowledgment

    def self.perform(protocol)
      Abacos::ProductAPI.confirm_product protocol
    end
  end
end
