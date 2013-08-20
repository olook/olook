module Abacos
  class IntegrateProductsObserver
    class << self

      def perform opts
        if REDIS.get("products_to_integrate").to_i.zero?
          Resque.enqueue(NotificationWorker, opts)
        else
          Resque.enqueue_in(5.minutes, NotificationWorker, opts)
        end
      end


      def products_to_be_integrated products_amount
        REDIS.incrby("products_to_integrate", products_amount)
      end

      def decrement_products_to_be_integrated!
        REDIS.decrby("products_to_integrate", 1)
      end

      def notify_when_integration_finish(opts)
        # when it's done
        # Resque.enqueue_in(5.minutes, NotificationWorker, opts)
      end
    end
  end
end
