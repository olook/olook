# -*- encoding : utf-8 -*-
FactoryGirl.define do
  factory :freight_price do
    association :shipping_company
    description 'Test freight price'

    zip_start '00000000'
    zip_end '10101010'

    weight_start 0.0
    weight_end 10.0
    
    delivery_time 2
    price 10.23
    cost 5.67
  end
end
