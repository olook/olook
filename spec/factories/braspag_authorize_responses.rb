# -*- encoding : utf-8 -*-

FactoryGirl.define do
  factory :clean_braspag_authorize_response, :class => BraspagAuthorizeResponse do
    correlation_id "1"
    success false
    error_message "MyString"
    braspag_transaction_id "MyString"
    amount "12.00"
    payment_method 1
    acquirer_transaction_id "MyString"
    authorization_code "MyString"
    return_code "MyString"
    return_message "MyString"
    status 1
    credit_card_token "MyString"

    factory :braspag_authorize_response, :parent => :clean_braspag_authorize_response do
      after(:create) do |braspag_authorize_response|
        braspag_authorize_response.update_attribute(:identification_code, "ee0d8edb-12db-455c-a1fa-d0000fc4368d")
      end
    end

    factory :payment_braspag, :parent => :credit_card do
      association :order, :factory => :clean_order
      after(:create) do |payment|
        payment.update_attribute(:identification_code, "ee0d8edb-12db-455c-a1fa-d0000fc4368d")
      end
    end

    factory :processed_braspag_authorize_response, :parent => :clean_braspag_authorize_response do
      processed true
    end

    factory :not_processed_braspag_authorize_response, :parent => :clean_braspag_authorize_response do
      processed false
    end
  end
end
