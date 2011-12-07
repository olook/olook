# -*- encoding : utf-8 -*-
class CreditCardValidator < ActiveModel::Validator
  def validate(record)
    record.instance_eval do
      validates_format_of :telephone, :with => CreditCard::PhoneFormat
      validates_format_of :credit_card_number, :with => CreditCard::CreditCardNumberFormat
      validates_format_of :security_code, :with => CreditCard::SecurityCodeFormat
      validates_format_of :user_birthday, :with => CreditCard::BirthdayFormat
      validates_format_of :expiration_date, :with => CreditCard::ExpirationDateFormat

      validates_presence_of :user_name
      validates_presence_of :bank
      validates_presence_of :credit_card_number
      validates_presence_of :security_code
      validates_presence_of :expiration_date
      validates_presence_of :user_identification
      validates_presence_of :telephone
      validates_presence_of :user_birthday
    end
  end
end
