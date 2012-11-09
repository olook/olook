module Admin::ApplicationHelper
  
  HUMANIZED_GATEWAYS = {
    1 => "Moip",
    2 => "Braspag"
  }

  def payment_with_origin(payment)
    "#{payment.type}#{payment.credit_type.try{|c| '('+c.code+')' }}"
  end

  def payment_status(status)
  	MoipCallback::STATUS[status.to_s]
  end

  def humanize_gateway(gateway)
    HUMANIZED_GATEWAYS[gateway]
  end

end

