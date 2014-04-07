# -*- encoding : utf-8 -*-
module Braspag
  class GatewayCaptureWorker
    extend Payments::Logger
    
    @queue = 'low'

    def self.perform(payment_id)
      begin
        log("Got payment [#{payment_id}] for capture processing")
        payment = ::CreditCard.find(payment_id)
        strategy = Payments::BraspagSenderStrategy.new(payment)
        strategy.credit_card_number = payment.credit_card_number
        strategy.process_capture_request
      rescue Exception => e
        log("Error when trying to capture transaction for payment [#{payment_id}]: #{e.message}")
        Resque.enqueue_in(15.minutes, Braspag::GatewayCaptureWorker, payment_id)
      end
    end

  end
end
