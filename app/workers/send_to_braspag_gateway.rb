# -*- encoding : utf-8 -*-
module Braspag
  class GatewaySenderWorker
    @queue = :order_status

    def self.perform(payment_id)

      payment = Payment.find(payment_id)

      cart_service = CartService.new(
        :cart => payment.cart,
        :gift_wrap => session[:gift_wrap],
        :coupon => coupon,
        :promotion => @promotion,
        :freight => session[:cart_freight],
        :credits => session[:cart_use_credits]
      )
      
      strategy = Payments::BraspagSenderStrategy.new(cart_service, payment)

      strategy.process_enqueued_request
    end
  end
end
