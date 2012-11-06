# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :braspag_capture_response do
    correlation_id 1
    success false
    processed false
    error_message "MyString"
    braspag_transaction_id "MyString"
    acquirer_transaction_id "MyString"
    amount "MyString"
    authorization_code "MyString"
    return_code "MyString"
    return_message "MyString"
    status 1
  end
end
