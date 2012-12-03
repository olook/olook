# == Schema Information
#
# Table name: payments
#
#  id                         :integer          not null, primary key
#  order_id                   :integer
#  url                        :text
#  created_at                 :datetime
#  updated_at                 :datetime
#  type                       :string(255)
#  state                      :string(255)
#  user_name                  :string(255)
#  credit_card_number         :string(255)
#  bank                       :string(255)
#  expiration_date            :string(255)
#  telephone                  :string(255)
#  user_birthday              :string(255)
#  payments                   :integer
#  gateway_status             :integer
#  gateway_code               :string(255)
#  gateway_type               :string(255)
#  payment_expiration_date    :datetime
#  reminder_sent              :boolean          default(FALSE)
#  gateway_status_reason      :string(255)
#  identification_code        :string(255)
#  cart_id                    :integer
#  credit_type_id             :integer
#  credit_ids                 :text
#  coupon_id                  :integer
#  total_paid                 :decimal(8, 2)
#  promotion_id               :integer
#  discount_percent           :integer
#  percent                    :decimal(8, 2)
#  gateway_response_id        :string(255)
#  gateway_response_status    :string(255)
#  gateway_token              :text
#  gateway_fee                :decimal(8, 2)
#  gateway_origin_code        :string(255)
#  gateway_transaction_status :string(255)
#  gateway_message            :string(255)
#  gateway_transaction_code   :string(255)
#  gateway_return_code        :integer
#  user_id                    :integer
#  gateway                    :integer
#  security_code              :string(255)
#

# -*- encoding : utf-8 -*-
class CreditCard < Payment

  BANKS_OPTIONS = ["Visa", "Mastercard", "AmericanExpress", "Diners", "Hipercard"]
  PAYMENT_QUANTITY = 6
  MINIMUM_PAYMENT = 30
  EXPIRATION_IN_MINUTES = 60

  # Credit Card Number formats
  SixToNineCreditCardNumberFormat = /^[0-9]{16,19}$/
  FourToSevenCreditCardNumberFormat = /^[0-9]{14,17}$/
  OneToFiveCreditCardNumberFormat = /^[0-9]{11,15}$/


  PhoneFormat = /^(?:\(11\)9\d{4}-\d{3,4}|\(\d{2}\)\d{4}-\d{4})$/

  SecurityCodeFormat = /^(\d{3}(\d{1})?)?$/
  BirthdayFormat = /^\d{2}\/\d{2}\/\d{4}$/
  ExpirationDateFormat = /^\d{2}\/\d{2}$/

  validates :user_name, :bank, :security_code, :expiration_date, :user_identification, :telephone, :user_birthday, :presence => true, :on => :create
  validate :apply_bank_number_of_digits, :on => :create
  validates_format_of :telephone, :with => PhoneFormat, :on => :create
  validates_format_of :security_code, :with => SecurityCodeFormat, :on => :create
  validates_format_of :user_birthday, :with => BirthdayFormat, :on => :create
  validates_format_of :expiration_date, :with => ExpirationDateFormat, :on => :create

  after_create :set_payment_expiration_date

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
      case bank
      when /Hipercard/
        validate_bank_credit_card_number SixToNineCreditCardNumberFormat
      when /Diners/ || /AmericanExpress/
        validate_bank_credit_card_number OneToFiveCreditCardNumberFormat
      else
        validate_bank_credit_card_number FourToSevenCreditCardNumberFormat
      end unless bank.blank?
  end

  private

  def validate_bank_credit_card_number bank_credit_card_number
    unless credit_card_number.match(bank_credit_card_number)
      errors.add :credit_card_number, "possui uma quantidade inválida"
    end
  end

end
