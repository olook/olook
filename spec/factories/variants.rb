# -*- encoding : utf-8 -*-
FactoryGirl.define do
  factory :variant do
    factory :basic_shoe_size_35 do
      association :product, :factory => :basic_shoe
      is_master false
      number '35A'
      description 'size 35'
      display_reference 'size-35'
      price 123.45
      inventory 10
      
      width 1
      height 1
      length 1
      weight 1.0
    end
  end
end
