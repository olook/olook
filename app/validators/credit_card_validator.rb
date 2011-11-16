# -*- encoding : utf-8 -*-
class CreditCardValidator < ActiveModel::Validator
  def validate(record)
    record.instance_eval do
      validates_presence_of :user_name, :credit_card_number, :security_code, :expiration_date, :user_identification, :telephone, :user_birthday
    end
  end
end
