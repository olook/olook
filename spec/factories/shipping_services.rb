# -*- encoding : utf-8 -*-
FactoryGirl.define do
  factory :shipping_service do
    name 'olook'
    erp_code 'olook'

    factory :tex do
      name 'TEX'
      erp_code 'TEX'
    end
    factory :pac do
      name 'PAC'
      erp_code 'PAC'
    end
  end
end
