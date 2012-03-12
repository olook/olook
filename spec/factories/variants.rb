# -*- encoding : utf-8 -*-
FactoryGirl.define do
  factory :variant do
    association :product, :factory => :basic_shoe
    is_master false
    number { "number#{Random.rand 10000}" }
    description 'size X'
    display_reference 'size-X'

    width 1
    height 1
    length 1
    weight 1.0

    price 0.0
    inventory 0

    factory :basic_bag_simple do
      description 'bag'
      price 123.45
      inventory 10
    end

    factory :basic_accessory_simple do
      description 'acessory'
      price 123.45
      inventory 10
    end

    factory :basic_shoe_size_35 do
      number '35'
      description '35'
      display_reference 'size-35'
      price 123.45
      inventory 10
    end

    factory :basic_shoe_size_37 do
      number '37A'
      description '37'
      display_reference 'size-37'
      price 124.19
      inventory 5
    end

    factory :basic_shoe_size_40 do
      number '40A'
      description '40'
      display_reference 'size-45'
      price 125.45
      inventory 5
    end
  end
end

