# -*- encoding : utf-8 -*-

FactoryGirl.define do
  factory :clean_braspag_capture_response, :class => BraspagCaptureResponse do
    correlation_id "1"
    success false
    error_message "MyString"
    braspag_transaction_id "MyString"
    amount "12.00"
    acquirer_transaction_id "MyString"
    authorization_code "MyString"
    return_code "MyString"
    return_message "MyString"
    status 1
    processed false

    factory :braspag_capture_response, :parent => :clean_braspag_capture_response do
      after_create do |braspag_capture_response|
        braspag_capture_response.update_attribute(:order_id, "ee0d8edb-12db-455c-a1fa-d0000fc4368d")
      end
    end

    factory :processed_braspag_capture_response, :parent => :clean_braspag_capture_response do
      processed true
    end

    factory :not_processed_braspag_capture_response, :parent => :clean_braspag_capture_response do
      processed false
    end
  end
end

