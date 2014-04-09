# -*- encoding : utf-8 -*-
module Abacos
  class ConfirmOrderStatus
    @queue = 'medium'

    def self.perform(protocol)
      Abacos::OrderAPI.confirm_order_status protocol
    end
  end
end
