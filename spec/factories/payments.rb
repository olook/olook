# -*- encoding : utf-8 -*-
FactoryGirl.define do
  factory :credit_card do
    url 'www.payment.com'
    credit_card_number '1234435678964567'
    user_name 'User name'
    bank 'Visa'
    security_code '187'
    expiration_date '12/11'
    user_identification '197.620.036-91'
    telephone '(35)3456-6849'
    user_birthday '12/09/1976'
    receipt 'AVista'
  end

  factory :debit do
    url 'www.payment.com'
    bank 'Visa'
    receipt 'AVista'
  end

  factory :billet do
    url 'www.payment.com'
    receipt 'AVista'
  end

  factory :payment do
    url 'www.payment.com'
  end
end

