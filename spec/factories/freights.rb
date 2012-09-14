# -*- encoding : utf-8 -*-
FactoryGirl.define do
  factory :freight do
    association :address, :factory => :address
    association :shipping_service, :factory => :tex
    city nil
    complement nil
    cost 5.67
    country nil
    delivery_time 4
    neighborhood nil
    number nil
    price 10.23
    state nil
    street nil
    telephone nil
    zip_code nil
  end
end
