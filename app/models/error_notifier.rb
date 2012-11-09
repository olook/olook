class ErrorNotifier

  def initialize(gateway, error)

  end
#        error_message = "Moip Request #{error.message} - Order Number #{payment.try(:order).try(:number)} - Payment Expiration #{payment.payment_expiration_date} - User ID #{payment.try(:user_id)}"
#      log(error_message)
#      NewRelic::Agent.add_custom_parameters({:error_msg => error_message})
#      Airbrake.notify(
#        :error_class   => "Moip Request",
#        :error_message => error_message
#      )
end
