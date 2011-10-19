# -*- encoding : utf-8 -*-
FactoryGirl.define do
  factory :variant do
    factory :basic_shoe_size_35 do
      association :product, :factory => :basic_shoe
      number '35A'
      description 'size 35'
      display_reference 'size-35'
      price 123.45
      inventory 10
    end
  end
end
