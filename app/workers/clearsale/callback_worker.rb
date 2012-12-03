# -*- encoding : utf-8 -*-
module Clearsale
  class CallbackWorker
    @queue = :order_status

    def self.perform
      if Setting.send_to_clearsale || Setting.force_send_to_clearsale
        responses = ClearsaleOrderResponse.to_be_processed
        responses.each do |response|
          
          if response.has_pending_status?
            new_response = OrderAnalysisService.check_results(response.order)
            unless new_response.has_pending_status?
              process_response new_response
              response.update_attribute("processed", true)
            end
          else
            process_response response
          end

        end
      end
    end

    def process_response(clearsale_response)
      if clearsale_response.has_an_accepted_status?
       capture_transaction(clearsale_response.order.payments)
       clearsale_response.update_attribute("processed", true)
      elsif clearsale_response.has_a_rejected_status?
        cancel_transaction(clearsale_response.order.payments)
        clearsale_response.update_attribute("processed", true)
      end
    end

    def capture_transaction(payments)
       payments.each do |payment|
        if payment.is_a?(CreditCard)
          strategy = Payments::BraspagSenderStrategy.new(nil, payment)
          strategy.credit_card_number = payment.credit_card_number
          strategy.process_capture_request 
        end
      end
    end

    def cancel_transaction(payments)
      payments.each do |payment|
        if payment.is_a?(CreditCard)
          payment.set_state(:cancel)
          if payment.order && payment.order.reload.canceled?
            Resque.enqueue(Abacos::CancelOrder, payment.order.number)
          end
        end
      end
    end

  end
end
