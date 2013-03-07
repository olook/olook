class ErrorNotifier

  def self.send_notifier(gateway_name, error, payment)
    error_message = "#{gateway_name} Request #{error.message} - Order Number #{payment.try(:id)} - Payment Expiration #{payment.payment_expiration_date} - User ID #{payment.try(:user_id)}"
      log("#{error.class}: #{error_message}\n#{error.backtrace.to_a.join("\n")}")
      NewRelic::Agent.add_custom_parameters({:error_msg => error_message})
      Airbrake.notify(error,
        :error_class   => "#{gateway_name} Request [#{error.class}]",
        :error_message => error_message
      )
  end

  def self.log(message, logger = Rails.logger, level = :error)
    logger.send(level, message)
  end
end
