# -*- encoding : utf-8 -*-
class Payment < ActiveRecord::Base
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
    "9" => :refouded
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
  has_one :payment_response

  def save_with(payment_url, order)
    self.url, self.order = payment_url, order
    save
  end

  def set_state(status)
    event = STATUS[status]
    send(event) if event
  end
end
