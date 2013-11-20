# -*- encoding : utf-8 -*-
module Admin::ApplicationHelper

  HUMANIZED_GATEWAYS = {
    1 => "Moip",
    2 => "Braspag",
    3 => "Olook",
    4 => "Mercado Pago"
  }

  def payment_with_origin(payment)
    "#{payment.type}#{payment.credit_type.try{|c| '('+c.code+')' }}"
  end

  def payment_status(status)
  	MoipCallback::STATUS[status.to_s]
  end

  def braspag_authorize_status(status)
    BraspagAuthorizeResponse::STATUS[status]
  end

  def braspag_capture_status(status)
    BraspagCaptureResponse::STATUS[status]
  end

  def humanize_gateway(gateway)
    HUMANIZED_GATEWAYS[gateway]
  end

  def reason_for credit

    case credit.source
      when "loyalty_program_refund_debit"
        "Estorno de compra"
      when "loyalty_program_debit"
        "Crédito usado"
      else
        credit.reason
    end
  end

  def formatted_visibility visibility_code
    if visibility_code.to_s == '1'
      'Catálogos [1]'
    elsif visibility_code.to_s == '2'
      'Olooklet [2]'
    else
      'Em todo o site [3]'
    end
  end

end

