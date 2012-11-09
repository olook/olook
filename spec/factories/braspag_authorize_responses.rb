# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :braspag_authorize_response do
    correlation_id 1
    success false
    error_message "MyString"
    identification_code "MyString"
    braspag_order_id "MyString"
    braspag_transaction_id "MyString"
    amount "MyString"
    payment_method 1
    acquirer_transaction_id "MyString"
    authorization_code "MyString"
    return_code "MyString"
    return_message "MyString"
    status 1
    credit_card_token "MyString"
    processed false
  end
end
