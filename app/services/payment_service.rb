class PaymentService

  def self.create_sender_strategy(cart_service, payment)

    if ((payment.is_a? CreditCard) && (payment.bank == "Hipercard" || payment.bank == "AmericanExpress")) || (!payment.is_a? CreditCard)
      return Payments::MoipSenderStrategy.new(cart_service, payment)
    end

    if is_a_rebuyer?(cart_service.cart.user)
      braspag_sender_strategy_for payment, cart_service
    end

    if ((Random.rand(100)+1) <= Setting.braspag_percentage.to_i)
      if Setting.braspag_whitelisted_only && !cart_service.cart.user.email.match(/(olook\.com\.br$)/)
        Payments::MoipSenderStrategy.new(cart_service, payment)
      else
        braspag_sender_strategy_for payment, cart_service
      end
    else
      Payments::MoipSenderStrategy.new(cart_service, payment)
    end
  end

  private
    def self.is_a_rebuyer?(user)
      Setting.braspag_rebuyers && CreditCard.where(user_id: user.id, state: ['authorized','completed']).any?
    end

    def self.braspag_sender_strategy_for payment, cart_service
      # TODO => MOVE this to braspag sender strategy constructor 
      sender_strategy = Payments::BraspagSenderStrategy.new(payment)
      sender_strategy.cart_service = cart_service
      sender_strategy.credit_card_number = payment.credit_card_number
      sender_strategy
    end
end