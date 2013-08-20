# -*- encoding : utf-8 -*-
module Abacos
  class ConfirmProduct
    @queue = :product_acknowledgment

    def self.perform(protocol)
      begin
        Abacos::ProductAPI.confirm_product protocol
        Abacos::IntegrateProductsObserver.decrement_products_to_be_integrated!
      rescue Exception => e
        Abacos::IntegrateProductsObserver.decrement_products_to_be_integrated!
        Airbrake.notify(
          :error_class   => "Abacos Confirm Product product",
          :error_message => e.message
        )
      end
    end
  end
end
