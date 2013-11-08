module Payments
  class MercadoPagoSenderStrategy
    include Payments::Logger

    attr_accessor :cart_service, :payment, :response, :return_code

    def initialize(cart_service, payment)
      @cart_service, @payment = cart_service, payment
      log("Initializing MercadoPagoSenderStrategy with cart_service: #{cart_service.inspect} and payment: #{payment.inspect}")
    end

    def send_to_gateway
      @payment
    end

    def payment_successful?
      true
    end
  end
end