class PaymentService

  def self.create_sender_strategy(cart_service, payment)

    if (payment.is_a? CreditCard) && (payment.bank == "Hipercard" || payment.bank == "AmericanExpress")
      return Payments::MoipSenderStrategy.new(cart_service, payment)
    end

    if ((Random.rand(100)+1) <= Setting.braspag_percentage.to_i)
      if Setting.braspag_whitelisted_only && !cart_service.cart.user.email.match(/(olook\.com\.br$)/)
        Payments::MoipSenderStrategy.new(cart_service, payment)
      else
        Payments::BraspagSenderStrategy.new(cart_service, payment)        
      end
    else
      Payments::MoipSenderStrategy.new(cart_service, payment)
    end

  end

end