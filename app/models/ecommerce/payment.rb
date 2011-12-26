# -*- encoding : utf-8 -*-
class Payment < ActiveRecord::Base
  MINIMUM_VALUE = 5.0
  SUCCESSFUL_STATUS = 'Sucesso'
  FAILURE_STATUS = 'Falha'
  REASON = 'Pagamento'
  RECEIPT = 'AVista'
  STATUS = {
    "1" => :authorized,
    "2" => :started,
    "3" => :billet_printed,
    "4" => :completed,
    "5" => :canceled,
    "6" => :under_analysis,
    "7" => :reversed,
    "8" => :under_review,
    "9" => :refunded
  }

  RESPONSE_STATUS = {
    "Autorizado" => "Autorizado",
    "Iniciado" => "Iniciado",
    "BoletoImpresso" => "Boleto Impresso",
    "Completo" => "Completo",
    "Cancelado" => "Cancelado",
    "EmAnalise" => "Em Análise",
    "Estornado" => "Estornado",
    "EmRevisao" => "Em Revisão",
    "Reembolsado" => "Reembolsado"
  }

  attr_accessor :receipt, :user_identification

  belongs_to :order
  has_one :payment_response, :dependent => :destroy

  def credit_card?
    (self.type == "CreditCard") ? true : false
  end

  def expired_and_waiting_payment?
    (self.expired? && self.order.state == "waiting_payment") ? true : false
  end

  def expired?
    Time.now > self.payment_expiration_date if self.payment_expiration_date
  end

  def set_payment_expiration_date
    update_attributes(:payment_expiration_date => build_payment_expiration_date)
  end

  def save_with(payment_url, order)
    self.url, self.order = payment_url, order
    save
  end

  def set_state(status)
    event = STATUS[status]
    send(event) if event
  end

  def refund_order
    order.refunded
  end

  def review_order
    order.under_review
  end

  def cancel_order
    order.canceled
  end

  def authorize_order
    order.authorized
  end
end

