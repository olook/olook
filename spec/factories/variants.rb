# -*- encoding : utf-8 -*-
FactoryGirl.define do
  factory :variant do
    association :product, :factory => [:shoe, :casual]
    is_master false
    number { "number#{Random.rand 10000}" }
    description 'size X'
    display_reference 'size-X'

    width 1
    height 1
    length 1
    weight 1.0

    price 0.0
    retail_price 0.0
    inventory 0
    initial_inventory 0

    trait :in_stock do
      inventory 10
    end

    trait :sold_out do
      inventory 0
    end

    factory :shoe_variant do
      inventory 5
      price 125.45
      retail_price 125.45
      description '35'
      display_reference 'size-35'

      factory :basic_shoe_size_35 do
        price 123.45
        retail_price 123.45
        inventory 10
        number '35'
      end

      factory :basic_shoe_size_37 do
        number '37A'
        description '37'
        display_reference 'size-37'
        price 124.19
        retail_price 124.19
      end


      factory :basic_shoe_size_39 do
        number '39A'
        description '39'
        display_reference 'size-39'
      end

      factory :basic_shoe_size_40 do
        number '40A'
        description '40'
        display_reference 'size-45'
      end
    end

    factory :bag_variant do
      description 'bag'
      inventory 1
      price 100.45
      retail_price 100.45

      factory :basic_bag_normal do
        #TODO: refactor instances to this factory to use :bag
      end

      factory :basic_bag_simple do
        association :product, :factory => :basic_bag
        price 123.45
        retail_price 123.45
        inventory 10
      end
    end

    factory :basic_accessory_simple do
      description 'acessory'
      price 123.45
      retail_price 123.45
      inventory 10
    end

    factory :yellow_shirt do
      description 'garment'
      price 123.45
      retail_price 123.45
      inventory 10
    end
  end
end

