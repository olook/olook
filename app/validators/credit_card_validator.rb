# -*- encoding : utf-8 -*-
class CreditCardValidator < ActiveModel::Validator
  def validate(record)
    record.instance_eval do
      validates_presence_of :user_name, :credit_card_number, :security_code, :expiration_date, :user_identification, :telephone, :user_birthday
      validates_format_of :telephone, :with => CreditCard::PhoneFormat
      validates_format_of :credit_card_number, :with => CreditCard::CreditCardNumberFormat
    end
  end
end
