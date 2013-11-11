class PaymentService

  def self.create_sender_strategy(cart_service, payment)
    if (payment.is_a? MercadoPagoPayment)
      return Payments::MercadoPagoSenderStrategy.new(cart_service, payment)
    end

    if ((payment.is_a? CreditCard) && (payment.bank == "Hipercard" || payment.bank == "AmericanExpress")) || (!payment.is_a? CreditCard)
      return Payments::MoipSenderStrategy.new(cart_service, payment)
    end

    payment.save
    braspag_sender_strategy_for payment, cart_service
  end

  private
    def self.braspag_sender_strategy_for payment, cart_service
      # TODO => MOVE this to braspag sender strategy constructor 
      sender_strategy = Payments::BraspagSenderStrategy.new(payment)
      sender_strategy.cart_service = cart_service
      sender_strategy.credit_card_number = payment.credit_card_number
      sender_strategy
    end
end
