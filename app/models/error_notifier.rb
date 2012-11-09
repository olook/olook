class ErrorNotifier

  def self.send(gateway_name, error, payment)

    error_message = "#{gateway_name} Request #{error.message} - Order Number #{payment.try(:order).try(:number)} - Payment Expiration #{payment.payment_expiration_date} - User ID #{payment.try(:user_id)}"
      log(error_message)
      NewRelic::Agent.add_custom_parameters({:error_msg => error_message})
      Airbrake.notify(
        :error_class   => "#{gateway_name} Request",
        :error_message => error_message
      )
  end

  def self.log(message, logger = Rails.logger, level = :error)
    logger.send(level, message)
  end
end
