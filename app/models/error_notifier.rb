class ErrorNotifier

  def self.send_notifier(gateway_name, error, payment)
    error_message = "#{gateway_name} Request #{error.message} - Order Number #{payment.try(:id)} - Payment Expiration #{payment.payment_expiration_date} - User ID #{payment.try(:user_id)}"
    log(_body = "#{error.class}: #{error_message}\n#{error.backtrace.to_a.join("\n")}")
    ActionMailer::Base.mail(:from => "admin@olook.com.br", :to => "incidentes@olook.com.br", :subject => "ErrorNotifier: #{error_message}", :body => "<pre>#{_body}</pre>").deliver
    NewRelic::Agent.add_custom_parameters({:error_msg => error_message})
    Airbrake.notify(error,
      :error_class   => "#{gateway_name} Request [#{error.class}]",
      :error_message => error_message,
      :backtrace => error.backtrace
    )
  end

  def self.log(message, logger = Rails.logger, level = :error)
    logger.send(level, message)
  end
end
