module Payments
  class BraspagSenderStrategy

    attr_accessor :cart_service, :payment, :credit_card_number, :response

    def initialize(cart_service, payment)
      @cart_service, @payment = cart_service, payment
    end

    def send_to_gateway
      ##TODO call braspag gem and set response
      binding.pry
      payment
    end
    
  end
end