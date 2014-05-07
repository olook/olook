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
        log("#{Time.zone.now.strftime("[%Y-%m-%d %H:%M:%s]")} - Error when trying to capture transaction for payment [#{payment_id}]: #{e.class} #{e.message}\n#{e.backtrace.join("\n")}")
        Resque.enqueue_in(15.minutes, Braspag::GatewayCaptureWorker, payment_id)
      end
    end

  end
end
