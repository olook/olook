# -*- encoding : utf-8 -*-
FactoryGirl.define do
  factory :shipping_company do
    name 'Test shipping company'
    priority 1
    erp_delivery_service 'delivery'
  end
end
