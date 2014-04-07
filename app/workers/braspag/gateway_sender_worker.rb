# -*- encoding : utf-8 -*-
module Braspag
  class GatewaySenderWorker
    extend Payments::Logger
    @queue = 'low'

    def self.perform(payment_id)
      begin
        log("Got payment [#{payment_id}] for sending it to analysis processing")
        payment = ::CreditCard.find(payment_id)
        strategy = Payments::BraspagSenderStrategy.new(payment)
        strategy.credit_card_number = payment.credit_card_number
        strategy.process_enqueued_request
      rescue Exception => e
        log("Error on sending payment [#{payment_id}] for processing")
        ErrorNotifier.send_notifier("GatewaySenderWorker", e, strategy.payment)
      end
    end

  end
end
