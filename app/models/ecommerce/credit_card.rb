# -*- encoding : utf-8 -*-
class CreditCard < Payment

  BANKS_OPTIONS = ["Visa", "Mastercard", "Diners"]
  PAYMENT_QUANTITY = 6
  MINIMUM_PAYMENT = 30
  EXPIRATION_IN_MINUTES = 60

  # Credit Card Number formats
  SixCreditCardNumberFormat = /^[0-9]{16}$/
  FourToSixCreditCardNumberFormat = /^[0-9]{14,16}$/


  PhoneFormat = /^(?:\(\d{2}\)(9){0,1}[2-9]\d{3}-\d{4})$/

  SecurityCodeFormat = /^(\d{3}(\d{1})?)?$/
  BirthdayFormat = /^\d{2}\/\d{2}\/\d{4}$/
  ExpirationDateFormat = /^\d{2}\/\d{2}$/

  validates :user_name, :bank, :security_code, :expiration_date, :user_identification, :telephone, :credit_card_number, :presence => true, :on => :create
  validate :apply_bank_number_of_digits, :on => :create
  validates_format_of :telephone, :with => PhoneFormat, :on => :create
  validates_format_of :security_code, :with => SecurityCodeFormat, :on => :create
  validates_format_of :user_birthday, :with => BirthdayFormat, :on => :create, :unless => lambda{|cc| cc.user_birthday.nil? || cc.user_birthday.empty? }
  validates_format_of :expiration_date, :with => ExpirationDateFormat, :on => :create
  validates_length_of :user_name, maximum: 100, :on => :create

  # THIS VALIDATION SHOULD OCCUR ONLY ON CREATE, BECAUSE WE ENCRYPT THE CREDIT_CARD NUMBER AND SAVE IT
  validates_with CreditCardNumberValidator, :attributes => [:credit_card_number], :on => :create
  validates_with UserIdentificationValidator, :attributes => [:user_identification], :on => :create

  before_create :set_payment_expiration_date
  before_validation(on: :create) do
    detect_credit_card_type
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

  def expired_and_waiting_payment?
    (self.expired? && self.order.state == "waiting_payment") ? true : false
  end

  def expired?
    Time.now > self.payment_expiration_date if self.payment_expiration_date
  end

  def self.installments_number_for(order_total)
    number = (order_total / MINIMUM_PAYMENT).to_i
    number = PAYMENT_QUANTITY if number > PAYMENT_QUANTITY
    (number == 0) ? 1 : number
  end

  def encrypt_credit_card
      number = self.credit_card_number
      last_digits = 4
      self.credit_card_number = "XXXXXXXXXXXX#{number[(number.size - last_digits)..number.size]}"
      self.security_code = nil
  end

  def apply_bank_number_of_digits
    unless bank.blank?
      if bank.match(/Diners/)
        validate_bank_credit_card_number FourToSixCreditCardNumberFormat
      else
        validate_bank_credit_card_number SixCreditCardNumberFormat
      end
    end
  end

  def cancelled_at_authorization?
    if gateway == 2
      braspag_responses = BraspagAuthorizeResponse.where("identification_code = ?", identification_code)
      last_response = braspag_responses.last
      return true if last_response && last_response.problems_with_credit_card_validation?
    end
    false
  end

  private

  def validate_bank_credit_card_number bank_credit_card_number
    unless credit_card_number.match(bank_credit_card_number)
      errors.add :credit_card_number, "possui uma quantidade inválida"
    end
  end

  def detect_credit_card_type
    return bank unless bank.blank?
    self.bank = CreditCardDetectorService.detect(credit_card_number)
  end
end
