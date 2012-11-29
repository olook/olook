# -*- encoding : utf-8 -*-
module Clearsale
  class CallbackWorker
    @queue = :order_status

    def self.perform
      if Setting.send_to_clearsale || Setting.force_send_to_clearsale
        responses = ClearsaleOrderResponse.to_be_processed
        responses.each do |response|
          clearsale_response = OrderAnalysisService.check_results(response.order)
          if clearsale_response.has_an_accepted_status?
            response.order.payments.each do |payment|
              strategy = Payments::BraspagSenderStrategy.new(nil, payment)
              strategy.credit_card_number = payment.credit_card_number
              strategy.process_capture_request
            end
            response.update_attribute("processed", true)
          elsif clearsale_response.has_a_rejected_status?
            response.update_attribute("processed", true)
          end          
        end
      end
    end

  end
end
