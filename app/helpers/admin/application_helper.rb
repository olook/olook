# -*- encoding : utf-8 -*-
module Admin::ApplicationHelper

  HUMANIZED_GATEWAYS = {
    1 => "Moip",
    2 => "Braspag",
    3 => "Olook"
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

  def prepare_message hash
    case hash.fetch(:code)
    when "0"
      "Produtos adicionados a campanha com sucesso"
    when "1"
      "Alguns produtos não foram encontrados: #{hash.fetch(:fail_product_ids).join(',')}"
    when "2"
      "Não foram adicionados nenhum produto a campanha"
    end
  end

end

