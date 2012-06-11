# -*- encoding : utf-8 -*-
FactoryGirl.define do
  factory :shipping_service do
    name 'Test shipping service'
    erp_code 'Test'
    priority 1
    erp_delivery_service 'delivery'
  end
end
