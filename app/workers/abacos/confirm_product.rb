# -*- encoding : utf-8 -*-
module Abacos
  class ConfirmProduct
    @queue = :product_acknowledgment

    def self.perform(protocol)
      begin
        Abacos::ProductAPI.confirm_product protocol
        Abacos::IntegrateProductsObserver.mark_product_integrated_as_success!
      rescue Exception => e
        Abacos::IntegrateProductsObserver.mark_product_integrated_as_failure!
        Airbrake.notify(
          :error_class   => "Abacos Confirm Product",
          :error_message => e.message
        )
      end
    end
  end
end
