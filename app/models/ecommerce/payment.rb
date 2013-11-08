# -*- encoding : utf-8 -*-
class Payment < ActiveRecord::Base
  MINIMUM_VALUE = BigDecimal.new("5.00")
  SUCCESSFUL_STATUS = 'Sucesso'
  FAILURE_STATUS = 'Falha'
  CANCELED_STATUS = 'Cancelado'
  REASON = 'Pagamento'
  RECEIPT = 'AVista'

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

  GATEWAYS = {
    :moip => 1,
    :braspag => 2,
    :olook => 3
  }

  attr_accessor :receipt, :user_identification

  belongs_to :order
  belongs_to :user
  belongs_to :cart
  belongs_to :credit_type

  after_create :generate_identification_code

  def self.for_erp
    where(type: ['CreditCard','Billet', 'Debit', 'MercadoPagoPayment'])
  end

  def self.for_loyalty
    where(type: 'CreditPayment').joins(:credit_type).where(:credit_types => {code: 'loyalty_program'})
  end

  def self.for_redeem
    where(type: 'CreditPayment').joins(:credit_type).where(:credit_types => {code: 'redeem'})
  end

  def self.for_invite
    where(type: 'CreditPayment').joins(:credit_type).where(:credit_types => {code: 'invite'})
  end

  def self.for_credits
    where(type: 'CreditPayment')
  end

  def self.for_promotion
    where(type: 'PromotionPayment')
  end

  def self.for_olooklet
    where(type: 'OlookletPayment')
  end

  def self.for_gift
    where(type: 'GiftPayment')
  end

  def self.for_coupon
    where(type: 'CouponPayment')
  end

  def self.for_billet_discount
    where(type: 'BilletDiscountPayment')
  end

  def self.for_debit_discount
    where(type: 'DebitDiscountPayment')
  end

  def self.with_discount
    where(type: ['BilletDiscountPayment', 'CouponPayment', 'GiftPayment', 'OlookletPayment', 'PromotionPayment', 'CreditPayment', "FacebookShareDiscountPayment"])
  end

  def self.for_facebook_share_discount
    where(type: 'FacebookShareDiscountPayment')
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
        logger.warn "[PMTS] payment #{payment.id} was canceled. Check the reason"
        # payment.cancel_order?
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
      transition :authorized => :authorized, :if => lambda {|payment| payment.notify_unexpected_transition({ :event_name => "start", :current_state => "authorized" }) }
      transition :completed => :completed, :if => lambda {|payment| payment.notify_unexpected_transition({ :event_name => "start", :current_state => "completed" }) }
      transition :waiting_payment => :waiting_payment, :if => lambda {|payment| payment.notify_unexpected_transition({ :event_name => "start", :current_state => "waiting_payment" }) }
    end

    # "3" => :deliver,
    event :deliver do
      transition :started => :waiting_payment, :if => :deliver_payment?
      transition :waiting_payment => :waiting_payment, :if => lambda {|payment| payment.notify_unexpected_transition({ :event_name => "deliver", :current_state => "waiting_payment" }) }
      transition :under_review => :under_review
    end

    # "5" => :cancel,
    event :cancel do
      transition :started => :cancelled
      transition :waiting_payment => :cancelled
      transition :under_review => :cancelled
      transition :cancelled => :cancelled, :if => lambda {|payment| payment.notify_unexpected_transition({ :event_name => "cancel", :current_state => "cancelled" }) }
    end

    # "1" => :authorize
    event :authorize do
      transition :started => :authorized
      transition :waiting_payment => :authorized
      transition :under_review => :authorized
      transition :authorized => :authorized, :if => lambda {|payment| payment.notify_unexpected_transition({ :event_name => "authorize", :current_state => "authorized" }) }
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
      transition :reversed => :reversed
    end

    # "9" => :refund
    event :refund do
      transition :completed => :refunded
      transition :authorized => :refunded
      transition :under_review => :refunded
    end
  end

  def deliver_payment?
    true
  end

  def notify_unexpected_transition(opts = {})
      event_name = opts[:event_name]
      current_state = opts[:current_state]
      error_message = "Unexpected transition event. Payment: #{id} -> Event: #{event_name} - Current State: #{current_state}"
      Airbrake.notify(
        :error_class   => "Gateway Request",
        :error_message => error_message
      )
      true
  end

  def credit_card?
    (self.type == "CreditCard") ? true : false
  end

  def set_payment_expiration_date
    self.payment_expiration_date = build_payment_expiration_date if self.payment_expiration_date.nil?
  end

  def set_state(event)
    send(event) if event
  end

  def refund_order?
    order.refunded if (order && !order.payment_rollback?)
  end

  def review_order?
    order.under_review
  end

  def cancel_order?
    order.canceled if (order && !order.payment_rollback?)
  end

  def authorize_order?
    order.authorized if order
    !order.nil?
  end

  def reverse_order?
    order.reversed  if (order && !order.payment_rollback?)
  end

  def calculate_percentage!
    if self.order
      self.percent = ((100 * self.total_paid) / self.order.gross_amount)
    end
  end

  def sucess?
    gateway_response_status == Payment::SUCCESSFUL_STATUS
  end

  def build_response(response)
    write_attribute(:gateway_response_id, response["ID"])
    write_attribute(:gateway_response_status, response["Status"])
    write_attribute(:gateway_token, response["Token"])
    if response["RespostaPagamentoDireto"]
      write_attribute(:gateway_fee, response["RespostaPagamentoDireto"]["TaxaMoIP"])
      write_attribute(:gateway_origin_code, response["RespostaPagamentoDireto"]["CodigoMoIP"])
      write_attribute(:gateway_transaction_status, response["RespostaPagamentoDireto"]["Status"])
      write_attribute(:gateway_message, response["RespostaPagamentoDireto"]["Mensagem"])
      write_attribute(:gateway_transaction_code, response["RespostaPagamentoDireto"]["CodigoAutorizacao"])
      write_attribute(:gateway_return_code, response["RespostaPagamentoDireto"]["CodigoAutorizacao"])
    end
  end

  def status
    Payment::RESPONSE_STATUS[gateway_transaction_status]
  end

  def authorize_and_notify_if_is_a_billet
    if self.is_a?(Billet)
      self.authorize
      DevAlertMailer.notify(to: "rafael.manoel@olook.com.br", subject: "Ordem de numero #{ self.order.number } foi autorizada").deliver
    end
  end

  private

    def generate_identification_code
      #TODO: PASSAR A USAR UUID
      code = SecureRandom.uuid.delete("-")
      while Payment.find_by_identification_code(code)
        code = SecureRandom.uuid
      end
      update_attributes(:identification_code => code)
    end
end

