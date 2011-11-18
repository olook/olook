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

    factory :basic_shoe_size_40 do
      association :product, :factory => :basic_shoe
      number '40A'
      description 'size 40'
      display_reference 'size-45'
      price 123.45
      inventory 5
    end
  end
end
