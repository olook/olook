# -*- encoding : utf-8 -*-
# TODO essa classe ainda eh utilizada?
module Abacos
  class IntegrateOrderStatus
    @queue = 'urgent'

    def self.perform(klass, parsed_data)
      entity = klass.constantize.new parsed_data
      entity.integrate
    end
  end
end
