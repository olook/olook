# -*- encoding : utf-8 -*-
module Clearsale
  class CallbackWorker
    extend Payments::Logger

    @queue = :order_status

    def self.perform
      log("testing")
      if Setting.send_to_clearsale || Setting.force_send_to_clearsale
        responses = ClearsaleOrderResponse.to_be_processed
        responses.each do |response|

          if response.has_pending_status?
            new_response = OrderAnalysisService.check_results(response.order)
            if new_response.has_pending_status?
              response.update_attribute("last_attempt", Time.now)
            else
              process_response new_response
              response.update_attribute("processed", true)
            end
          else
            process_response response
          end

        end
      end
    end

    def self.process_response(clearsale_response)
      if clearsale_response.has_an_accepted_status?
       capture_transaction(clearsale_response.order.payments)
       clearsale_response.update_attribute("processed", true)
      elsif clearsale_response.has_a_rejected_status?
        cancel_transaction(clearsale_response.order.payments)
        clearsale_response.update_attribute("processed", true)
      end
    end

    def self.capture_transaction(payments)
       payments.each do |payment|
        if payment.is_a?(CreditCard)
          log("Enqueueing payment [#{payment.id}] for capture.")
          Resque.enqueue(Braspag::GatewayCaptureWorker, payment.id)
        end
      end
    end

    def self.cancel_transaction(payments)
      payments.each do |payment|
        if payment.is_a?(CreditCard)
          payment.set_state(:cancel)
          log("Enqueueing order [#{payment.order.number}] for cancelation.") if payment.order
          Resque.enqueue(Abacos::CancelOrder, payment.order.number) if payment.order
        end
      end
    end

  end
end
