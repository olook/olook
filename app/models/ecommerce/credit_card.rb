# -*- encoding : utf-8 -*-
class CreditCard < Payment
  attr_accessor :user_name, :credit_card_number, :bank, :security_code, :expiration_date, :telephone, :user_birthday, :payments

  BANKS_OPTIONS = ["Visa", "Mastercard", "AmericanExpress", "Diners", "Hipercard", "Aura"]
  PAYMENT_QUANTITY = 6

  PhoneFormat = /^\([0-9]{2}\)[0-9]{4}-[0-9]{4}$/
  CreditCardNumberFormat = /[0-9]{16}/
  SecurityCodeFormat = /^(\d{3}(\d{1})?)?$/
  BirthdayFormat = /^\d{2}\/\d{2}\/\d{4}$/
  ExpirationDateFormat = /^\d{2}\/\d{2}$/

  validates :user_name, :bank, :credit_card_number, :security_code, :expiration_date, :user_identification, :telephone, :user_birthday, :presence => true, :on => :create

  validates_with CreditCardValidator

  state_machine :initial => :started do
    after_transition :started => :canceled, :do => :cancel_order
    after_transition :under_analysis => :canceled, :do => :cancel_order
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

  private

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
end
