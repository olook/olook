# -*- encoding : utf-8 -*-
module Abacos
  class ConfirmProduct
    @queue = :front_to_abacos

    def self.perform(protocol)
      Abacos::ProductAPI.confirm_product protocol
    end
  end
end
