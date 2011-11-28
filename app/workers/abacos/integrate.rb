# -*- encoding : utf-8 -*-
module Abacos
  class Integrate
    @queue = :integrate

    def self.perform(klass, parsed_data)
      entity = klass.constantize.new parsed_data
      entity.integrate
    end
  end
end
