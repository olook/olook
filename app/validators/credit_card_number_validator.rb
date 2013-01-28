# -*- encoding : utf-8 -*-
class CreditCardNumberValidator < ActiveModel::Validator
  def validate(record)
    record.errors.add(:credit_card_number, I18n.t('activerecord.errors.models.credit_card.attributes.credit_card_number.invalid')) unless valid_credit_card?(record.credit_card_number)
  end

  private
  def valid_credit_card?(number)

    return false unless number

    # Hypercard
    return true if number.length > 16

    number = number.to_s.gsub(/\D/, "")
    number.reverse!

    relative_number = {'0' => 0, '1' => 2, '2' => 4, '3' => 6, '4' => 8, '5' => 1, '6' => 3, '7' => 5, '8' => 7, '9' => 9}

    sum = 0 

    number.split("").each_with_index do |n, i|
      sum += (i % 2 == 0) ? n.to_i : relative_number[n]
    end 

    sum % 10 == 0
  end

end
