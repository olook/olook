# -*- encoding : utf-8 -*-
FactoryGirl.define do
  factory :payment_response do
    association :payment, :factory => :credit_card
    total_paid 100.01
    gateway_fee 1.99
    gateway_code "0000.0826.1316"
    response_id     "201112130845546530000014392895"
    token "G2C061G1D1X2O1G3Z0H814F5Q5X4F6M513Z0O0Q0Z0W001X4J3W..."

    factory :authorized_payment do
      response_status "Sucesso"
      transaction_status "EmAnalise"
      message "Transação autorizada"
      transaction_code "046455"
      return_code 46455
    end
    factory :canceled_payment do
      response_status "Sucesso"
      transaction_status "Cancelado"
      message "Autorização negada"
      transaction_code nil
      return_code nil
    end
  end
end

