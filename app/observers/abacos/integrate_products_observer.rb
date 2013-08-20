module Abacos
  class IntegrateProductsObserver
    def self.start_with products_amount
      REDIS.incrby("products_to_integrate", products_amount)
    end
  end
end
