# -*- encoding : utf-8 -*-
module Braspag
  class GatewaySenderWorker
    @queue = :order_status

    def self.perform(payment_id)
      payment = ::CreditCard.find(payment_id)
      strategy = Payments::BraspagSenderStrategy.new(payment)
      strategy.credit_card_number = payment.credit_card_number
      begin
        strategy.process_enqueued_request
      rescue Exception => e
        ErrorNotifier.send_notifier("GatewaySenderWorker", e, strategy.payment)
      end
    end

  end
end
