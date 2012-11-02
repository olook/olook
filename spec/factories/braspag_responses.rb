# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :braspag_response do
    type ""
    correlation_id 1
    success false
    error_code "MyString"
    error_message "MyString"
    order_id "MyString"
    braspag_order_id 1
    braspag_transaction_id 1
    amount ""
    payment_method 1
    acquirer_transaction_id "MyString"
    authorization_code "MyString"
    return_code "MyString"
    return_message "MyString"
    transaction_status 1
    processed false
  end
end
