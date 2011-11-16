# -*- encoding : utf-8 -*-
FactoryGirl.define do
  factory :payment do
    url 'www.payment.com'
    payment_type Payment::TYPE[:billet]
    credit_card_number '1234435678964567'
    user_name 'User name'
    bank 'BancoDoBrasil'
    security_code '187'
    expiration_date '12/11'
    user_identification '123.456.567'
    telephone '(35)3456-6849'
    user_birthday '12/09/1976'
  end
end

