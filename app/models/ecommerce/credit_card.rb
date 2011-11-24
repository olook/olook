# -*- encoding : utf-8 -*-
class CreditCard < Payment
  attr_accessor :user_name, :credit_card_number, :bank, :security_code, :expiration_date, :user_identification, :telephone, :user_birthday, :payments, :receipt

  PhoneFormat = /^\([0-9]{2}\)[0-9]{4}-[0-9]{4}$/
  validates_with CreditCardValidator

  def to_s
    "CartaoCredito"
  end
end
