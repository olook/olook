# -*- encoding : utf-8 -*-
module Braspag
  class GatewaySenderWorker
    @queue = :order_status

    def self.perform(payment_id)
      payment = ::CreditCard.find(payment_id)

      strategy = Payments::BraspagSenderStrategy.new(nil, payment)

      strategy.credit_card_number = payment.credit_card_number

      payment.force_encrypt_credit_card
      payment.save

      strategy.process_enqueued_request
    end

  end
end
