# -*- encoding : utf-8 -*-
module Abacos
  class ConfirmProduct
    @queue = 'urgent'

    def self.perform(protocol, product_number)
      begin
        Abacos::ProductAPI.confirm_product protocol
        Abacos::IntegrateProductsObserver.mark_product_integrated_as_success!
      rescue Exception => e
        Abacos::IntegrateProductsObserver.mark_product_integrated_as_failure!(product_number, e.message)
        Airbrake.notify(
          :error_class   => "Abacos Confirm Product",
          :error_message => e.message
        )
      end
    end
  end
end
