class ErrorNotifier

  def self.send_notifier(gateway_name, error_message, payment)
    error_message = "#{gateway_name} Request #{error_message} - Order Number #{payment.try(:id)} - Payment Expiration #{payment.payment_expiration_date} - User ID #{payment.try(:user_id)}"
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
