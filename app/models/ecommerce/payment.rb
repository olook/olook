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
  belongs_to :credit_type
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
    state :authorized do 
      after_save do |payment|
        payment.authorize_order?
      end
    end
    
    #Iniciado - 2
    state :started
    
    #Cancelado - 5
    state :cancelled do 
      after_save do |payment|
        payment.cancel_order?
      end
    end
    
    #BoletoImpresso - 3
    state :waiting_payment
    
    #Estornado - 7
    state :reversed do 
      after_save do |payment|
        payment.reverse_order?
      end
    end

    #Reembolsado - 9
    state :refunded do 
      after_save do |payment|
        payment.refund_order?
      end
    end
    
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
      transition :started => :cancelled
      transition :waiting_payment => :cancelled
    end

    # "1" => :authorize
    event :authorize do
      transition :waiting_payment => :authorized     
      transition :under_review => :authorized
    end
    
    # "4" => :complete,
    event :complete do
      transition :authorized => :completed
      transition :under_review => :completed
    end

    # "6" => :review,
    event :review do
      transition :authorized => :under_review, :if => :review_order?
      transition :waiting_payment => :under_review, :if => :review_order?
    end
    
    # "7" => :reverse,
    event :reverse do
      transition :completed => :reversed
      transition :authorized => :reversed
      transition :under_review => :reversed
    end

    # "9" => :refund
    event :refund do
      transition :completed => :refunded
      transition :authorized => :refunded
      transition :under_review => :refunded
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
    order.refunded unless order.payment_rollback?
  end

  def review_order?
    order.under_review
  end

  def cancel_order?
    order.canceled unless order.payment_rollback?
  end

  #TODO: sempre responde true; Ele tem de checar se todos os outros pagamentos estao como authorized
  def authorize_order?
    order.authorized
    true
  end
  
  def reverse_order?
    order.reversed unless order.payment_rollback?
  end

  def user
    user = cart.try(:user)
    user ||= order.try(:user)
    user
  end
  
  def calculate_percentage!
    if self.order
      self.percent = ((100 * self.total_paid) / self.order.gross_amount)
    end
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

