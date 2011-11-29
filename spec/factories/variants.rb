# -*- encoding : utf-8 -*-
FactoryGirl.define do
  factory :variant do
    association :product, :factory => :basic_shoe
    is_master false
    number { "number#{Random.rand 10000}" }
    description 'size X'
    display_reference 'size-X'
    price 0.0
    inventory 0
    
    width  1
    height 1
    length 1
    weight 1.0
    
    factory :basic_shoe_size_35 do
      description 'size 35'
      display_reference 'size-35'
      price 123.45
      inventory 10
    end
  end
end
