# -*- encoding : utf-8 -*-
module Abacos
  class ConfirmPrice
    @queue = 'high'

    def self.perform(protocol)
      Abacos::ProductAPI.confirm_price protocol
    end
  end
end
