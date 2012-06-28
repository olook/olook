# -*- encoding : utf-8 -*-
FactoryGirl.define do
  factory :shipping_service do
      name 'TEX'
      erp_code 'TEX'
      priority 1
      erp_delivery_service 'delivery'
    factory :tex do
      name 'TEX'
      erp_code 'TEX'
      priority 1
      erp_delivery_service 'delivery'
    end
    factory :pac do
      name 'PAC'
      erp_code 'PAC'
      priority 1
      erp_delivery_service 'delivery'
    end
  end
end
