# -*- encoding : utf-8 -*-
module Braspag
  class GatewaySenderWorker
    @queue = :order_status

    def self.perform(payment_id)
      payment = Payment.find(payment_id)
      
      strategy = Payments::BraspagSenderStrategy.new(nil, payment)

      strategy.process_enqueued_request
    end
  end
end
