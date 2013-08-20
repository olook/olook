module Abacos
  class IntegrateProductsObserver
    class << self
      def products_to_be_integrated products_amount
        REDIS.incrby("products_to_integrate", products_amount)
      end

      def decrement_products_to_be_integrated!
        REDIS.decrby("products_to_integrate", 1)
      end
    end
  end
end
