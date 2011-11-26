# -*- encoding : utf-8 -*-
class CreditCard < Payment
  attr_accessor :user_name, :credit_card_number, :bank, :security_code, :expiration_date, :telephone, :user_birthday, :payments

  BANKS_OPTIONS = ["Visa", "Mastercard", "AmericanExpress", "Diners", "Hipercard", "Aura"]

  PhoneFormat = /^\([0-9]{2}\)[0-9]{4}-[0-9]{4}$/

  validates_with CreditCardValidator

  state_machine :initial => :started do
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
end
