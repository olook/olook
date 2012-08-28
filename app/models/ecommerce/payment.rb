# -*- encoding : utf-8 -*-
class Payment < ActiveRecord::Base
  MINIMUM_VALUE = BigDecimal.new("5.00")
  SUCCESSFUL_STATUS = 'Sucesso'
  FAILURE_STATUS = 'Falha'
  CANCELED_STATUS = 'Cancelado'
  REASON = 'Pagamento'
  RECEIPT = 'AVista'
  STATUS = {
    "1" => :authorize,
    "2" => :start,
    "3" => :deliver,
    "4" => :complete,
    "5" => :cancel,
    "6" => :review,
    "7" => :reverse,
    "9" => :refund
  }

  RESPONSE_STATUS = {
    "Autorizado" => "Autorizado",
    "Iniciado" => "Iniciado",
    "BoletoImpresso" => "Boleto Impresso",
    "Concluido" => "Completo",
    "Cancelado" => "Cancelado",
    "EmAnalise" => "Em Análise",
    "Estornado" => "Estornado",
    "Reembolsado" => "Reembolsado"
  }

  attr_accessor :receipt, :user_identification

  belongs_to :order
  belongs_to :cart
  has_one :payment_response, :dependent => :destroy

  after_create :generate_identification_code

  def self.for_erp
    where(type: ['CreditCard','Billet', 'Debit'])
  end
  
  state_machine :initial => :started do
    #Concluido - 4
    state :completed
    
    #EmAnalise - 6
    state :under_review
    
    #Autorizado - 1
    state :authorized
    
    #Iniciado - 2
    state :started
    
    #Cancelado - 5
    state :cancelled
    
    #BoletoImpresso - 3
    state :waiting_payment
    
    #Estornado - 7
    state :reversed

    #Reembolsado - 9
    state :refunded
    
    # "2" => :start,
    event :start do
      transition :started => :started
    end

    # "3" => :deliver,
    event :deliver do
      transition :started => :waiting_payment, :if => :deliver_payment?
    end
    
    # "5" => :cancel,
    event :cancel do
      transition :started => :cancelled, :if => :cancel_order?
      transition :waiting_payment => :cancelled, :if => :cancel_order?
    end

    # "1" => :authorize
    event :authorize do
      transition :waiting_payment => :authorized, :if => :authorize_order?
      transition :under_review => :authorized, :if => :authorize_order?
    end
    
    # "4" => :complete,
    event :complete do
      transition :authorized => :completed
      transition :under_review => :completed, :if => :authorize_order?
    end

    # "6" => :review,
    event :review do
      transition :waiting_payment => :under_review, :if => :review_order?
    end
    
    # "7" => :reverse,
    event :reverse do
      transition :completed => :reversed, :if => :reverse_order?
      transition :authorized => :reversed, :if => :reverse_order?
      transition :under_review => :reversed, :if => :reverse_order?
    end

    # "9" => :refund
    event :refund do
      transition :completed => :refunded, :if => :refund_order?
      transition :authorized => :refunded, :if => :refund_order?
      transition :under_review => :refunded, :if => :refund_order?
    end
  end
  
  def deliver_payment?
    # SAC::Notifier.notify(SAC::Notification.new(:billet, "Pedido: #{self.order.number} | Boleto", self.order)) if self.order
    true
  end

  def credit_card?
    (self.type == "CreditCard") ? true : false
  end

  def set_payment_expiration_date
    update_attributes(:payment_expiration_date => build_payment_expiration_date)
  end

  def set_state(status)
    event = STATUS[status]
    send(event) if event
  end

  def refund_order?
    order.refunded
  end

  def review_order?
    order.under_review
  end

  def cancel_order?
    order.canceled
  end

  def authorize_order?
    order.authorized
  end
  
  def reverse_order?
    order.reversed
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

