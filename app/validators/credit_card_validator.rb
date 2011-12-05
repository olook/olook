# -*- encoding : utf-8 -*-
class CreditCardValidator < ActiveModel::Validator
  def validate(record)
    record.instance_eval do
      validates_format_of :telephone, :with => CreditCard::PhoneFormat
      validates_format_of :credit_card_number, :with => CreditCard::CreditCardNumberFormat
      validates_format_of :security_code, :with => CreditCard::SecurityCodeFormat
      validates_format_of :user_birthday, :with => CreditCard::BirthdayFormat
      validates_format_of :expiration_date, :with => CreditCard::ExpirationDateFormat
    end
  end
end
