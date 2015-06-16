# -*- encoding : utf-8 -*-
module Abacos
  class Integrate
    @queue = 'medium'

    def self.perform(klass, parsed_data)
      begin
        Resque.enqueue klass.constantize, parsed_data
      rescue Exception => e
        product_number = parsed_data[:number] || parsed_data[:model_number]
        Abacos::IntegrateProductsObserver.mark_product_integrated_as_failure!(product_number, e.message)
        Airbrake.notify(
          :error_class   => "Abacos Confirm Product product",
          :error_message => e.message
        )
        raise e
      end
    end
  end
end
