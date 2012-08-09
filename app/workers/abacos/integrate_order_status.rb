# -*- encoding : utf-8 -*-
module Abacos
  class IntegrateOrderStatus
    @queue = :order_status

    def self.perform(klass, parsed_data)
      entity = klass.constantize.new parsed_data
      entity.integrate
    end
  end
end
