class PaymentService

  def self.create_sender_strategy(cart_service, payment)
    if Setting.braspag_whitelisted_only && cart_service.cart.user.email.match(/(olook\.com\.br$)/)
      Payments::BraspagSenderStrategy.new(cart_service, payment)
    else  
      Payments::MoipSenderStrategy.new(cart_service, payment)
    end

  end

end