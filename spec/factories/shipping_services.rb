# -*- encoding : utf-8 -*-
FactoryGirl.define do
  factory :shipping_service do
    factory :tex do
      name 'TEX'
      erp_code 'TEX'
      priority 1
    end
    factory :pac do
      name 'PAC'
      erp_code 'PAC'
      priority 1
    end
  end
end
