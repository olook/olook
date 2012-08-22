# -*- encoding : utf-8 -*-
class Payment < ActiveRecord::Base
  # TODO: Temporarily disabling paper_trail for app analysis
  #has_paper_trail
  MINIMUM_VALUE = BigDecimal.new("5.00")
  SUCCESSFUL_STATUS = 'Sucesso'
  FAILURE_STATUS = 'Falha'
  CANCELED_STATUS = 'Cancelado'
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

  after_create :generate_identification_code


  def credit_card?
    (self.type == "CreditCard") ? true : false
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
  
  private
    def generate_identification_code
      #TODO: PASSAR A USAR UUID
      code = SecureRandom.hex(16)
      while Payment.find_by_identification_code(code)
        code = SecureRandom.hex(16)
      end
      update_attributes(:identification_code => code)
    end
end

