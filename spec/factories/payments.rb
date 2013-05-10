# -*- encoding : utf-8 -*-
FactoryGirl.define do
  factory :credit_card do
    url 'www.payment.com'
    credit_card_number '4111111111111111'
    user_name 'User name'
    bank 'Visa'
    cart_id nil
    security_code '187'
    expiration_date '12/11'
    user_identification '197.620.036-91'
    telephone '(35)3456-6849'
    user_birthday '12/09/1976'
    receipt 'AVista'
    total_paid 12.34
    identification_code 'abc123'
    payments 1
  end

  factory :authorized_credit_card, :class => 'CreditCard' do
    url 'www.payment.com'
    credit_card_number '4111111111111111'
    user_name 'User name'
    bank 'Visa'
    cart_id nil
    security_code '187'
    expiration_date '12/11'
    user_identification '197.620.036-91'
    telephone '(35)3456-6849'
    user_birthday '12/09/1976'
    receipt 'AVista'
    total_paid 12.34
    identification_code 'abc123'
    payments 1
    state 'authorized'
  end

  factory :debit, :class => Debit do
    url 'www.payment.com'
    bank 'Visa'
    receipt 'AVista'
    total_paid 12.34
  end

  factory :billet, :class => Billet do
    url 'www.payment.com'
    receipt 'AVista'
    total_paid 12.34
    identification_code 'abcd1234'

      trait :waiting_payment do
        before(:create) do |billet|
          billet.state = "waiting_payment"
        end
      end

      trait :to_expire do
        before(:create) do |payment|
          expiration_date = (1.business_day.before(Time.zone.now) - 1.day) + 1.hour
          payment.expiration_date = expiration_date
        end
      end
  end

  trait :with_order do
    before(:create) do |payment|
      payment.order = FactoryGirl.create(:order)
    end
  end

  factory :payment do
    url 'www.payment.com'
  end

  factory :credit_card_with_response, :parent => :credit_card do
    gateway_response_status "Sucesso"
    gateway_transaction_status "EmAnalise"
    gateway_message "Transação autorizada"
    gateway_transaction_code "046455"
    gateway_return_code 46455
  end

  factory :credit_card_with_response_canceled, :parent => :credit_card do
    gateway_response_status "Sucesso"
    gateway_transaction_status "Cancelado"
    gateway_message "Transação não autorizada"
    gateway_transaction_code "046457"
    gateway_return_code 46455
    state :cancelled
  end

  factory :credit_card_with_response_authorized, :parent => :credit_card do
    state 'authorized'
    gateway_response_status "Sucesso"
    gateway_transaction_status "EmAnalise"
    gateway_message "Transação autorizada"
    gateway_transaction_code "046455"
    gateway_return_code 46455
  end

end

