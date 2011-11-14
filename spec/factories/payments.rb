# -*- encoding : utf-8 -*-
FactoryGirl.define do
  factory :payment do
    url 'www.payment.com'
    payment_type Payment::TYPE[:billet]
    user_name 'User name'
    credit_card_number '1234435678964567'
  end
end
