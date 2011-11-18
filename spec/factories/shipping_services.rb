# -*- encoding : utf-8 -*-
FactoryGirl.define do
  factory :shipping_service do
    name 'Test shipping service'
    priority 1
    erp_delivery_service 'delivery'
  end
end
