# -*- encoding : utf-8 -*-
module Abacos
  class Integrate
    @queue = :product

    def self.perform(klass, parsed_data)
      begin
        entity = klass.constantize.new parsed_data
        entity.integrate
      rescue Exception => e
        Abacos::IntegrateProductsObserver.mark_product_integrated_as_failure!
        Airbrake.notify(
          :error_class   => "Abacos Confirm Product product",
          :error_message => e.message
        )
      end
    end
  end
end
