# -*- encoding : utf-8 -*-
module Abacos
  class ConfirmPrice
    @queue = 'low'

    def self.perform(protocol)
      Abacos::ProductAPI.confirm_price protocol
    end
  end
end
