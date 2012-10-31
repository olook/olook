class PaymentService

  def self.create_sender_strategy(cart_service, payment)
    MoipSenderStrategy.new(cart_service, payment)
  end

end