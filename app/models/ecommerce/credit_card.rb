# -*- encoding : utf-8 -*-
class CreditCard < Payment
  attr_accessor :security_code

  BANKS_OPTIONS = ["Visa", "Mastercard", "AmericanExpress", "Diners", "Hipercard", "Aura"]
  PAYMENT_QUANTITY = 6
  MINIMUM_PAYMENT = 30
  EXPIRATION_IN_MINUTES = 60

  PhoneFormat = /^\([0-9]{2}\)[0-9]{4}-[0-9]{4}$/
  CreditCardNumberFormat = /^[0-9]{15,17}$/
  SecurityCodeFormat = /^(\d{3}(\d{1})?)?$/
  BirthdayFormat = /^\d{2}\/\d{2}\/\d{4}$/
  ExpirationDateFormat = /^\d{2}\/\d{2}$/

  validates :user_name, :bank, :credit_card_number, :security_code, :expiration_date, :user_identification, :telephone, :user_birthday, :presence => true, :on => :create

  validates_format_of :telephone, :with => PhoneFormat, :on => :create
  validates_format_of :credit_card_number, :with => CreditCardNumberFormat, :on => :create
  validates_format_of :security_code, :with => SecurityCodeFormat, :on => :create
  validates_format_of :user_birthday, :with => BirthdayFormat, :on => :create
  validates_format_of :expiration_date, :with => ExpirationDateFormat, :on => :create

  before_create :encrypt_credit_card
  after_create :set_payment_expiration_date

  state_machine :initial => :started do
    after_transition :started => :canceled, :do => :cancel_order
    after_transition :under_analysis => :canceled, :do => :cancel_order
    after_transition :started => :authorized, :do => :authorize_order
    after_transition :under_analysis => :authorized, :do => :authorize_order
    after_transition :authorized => :completed, :do => :complete_order
    after_transition :under_review => :completed, :do => :complete_order
    after_transition :authorized => :under_review, :do => :review_order
    after_transition :under_review => :refunded, :do => :refund_order
    after_transition :under_review => :reversed, :do => :reverse_order

    event :canceled do
      transition :started => :canceled, :under_analysis => :canceled
    end

    event :under_analysis do
      transition :started => :under_analysis
    end

    event :authorized do
      transition :started => :authorized, :under_analysis => :authorized
    end

    event :completed do
      transition :authorized => :completed, :under_review => :completed
    end

    event :under_review do
      transition :authorized => :under_review
    end

    event :reversed do
      transition :under_review => :reversed
    end
  end

  def to_s
    "CartaoCredito"
  end

  def human_to_s
    "Cartão de Crédito"
  end

  def build_payment_expiration_date
    EXPIRATION_IN_MINUTES.minutes.from_now
  end

  def self.installments_number_for(order_total)
    number = (order_total / MINIMUM_PAYMENT).to_i
    (number == 0) ? 1 : number
  end

  def self.user_data(user)
    {
      :user_name => user.name,
      :user_identification => user.cpf,
      :user_birthday => user.birthday
    }
  end

  private

  def encrypt_credit_card
    number = self.credit_card_number
    last_digits = 4
    self.credit_card_number = "XXXXXXXXXXXX#{number[(number.size - last_digits)..number.size]}"
  end

  def reverse_order
    order.reversed
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

  def complete_order
    order.completed
  end

  def authorize_order
    order.authorized
  end
end
