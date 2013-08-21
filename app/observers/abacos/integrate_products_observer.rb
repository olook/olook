module Abacos
  class IntegrateProductsObserver
    @queue = :notify_about_integration
    class << self
      def perform opts
        @opts = opts
        integration_finished? ? notify : schedule_notification
      end


      def products_to_be_integrated products_amount
        REDIS.set("products_to_integrate", products_amount)
      end

      def mark_product_integrated_as_success!
        decrement_products_to_be_integrated!
      end

      def mark_product_integrated_as_failure!
        decrement_products_to_be_integrated!
      end

      private
        def decrement_products_to_be_integrated!
          REDIS.decrby("products_to_integrate", 1)
        end

        def integration_finished?
          REDIS.get("products_to_integrate").to_i.zero?
        end

        def notify
          Resque.enqueue(NotificationWorker, @opts)
        end

        def schedule_notification
          Resque.enqueue_in(5.minutes, self, @opts)
        end
    end
  end
end
