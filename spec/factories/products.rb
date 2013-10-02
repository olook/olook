# -*- encoding : utf-8 -*-
FactoryGirl.define do
  factory :product do
    is_visible true

    trait :casual do
      after(:create) do |product|
        product.profiles << FactoryGirl.create(:casual_profile)
      end
    end

    trait :yellow do
      producer_code 'A1B2C3'
    end

    trait :blue do
      producer_code 'D4E5F6'
    end

    trait :in_collection do
      association :collection
    end

    trait :with_detail do
      after(:create) do |product|
        product.details << FactoryGirl.create(:product_color_detail)
      end
    end

    factory :shoe do
      name "Chanelle"
      description "Elegant black high-heeled shoe for executives"
      category Category::SHOE
      collection_id 1
      color_name 'Black'

      trait :invisible_shoe do
        is_visible false
      end

      trait :in_stock do
        after(:create) do |product|
          product.variants << FactoryGirl.create(:shoe_variant, :in_stock)
        end
      end

      trait :sold_out do
        after(:create) do |product|
          product.variants << FactoryGirl.create(:shoe_variant, :sold_out)
        end
      end

      trait :with_plenty_of_stock do
        after(:create) do |product|
          product.variants << FactoryGirl.create(:shoe_variant, inventory: 10)
        end
      end

      sequence :model_number do |n|
        "CSH01#{n}"
      end

      factory :red_slipper do
        name "Red Slipper"
        description "Red Slipper with Glitter"
        model_number 'SL-RD'
      end

      factory :silver_slipper do
        name "Silver Slipper"
        description "Silver Slipper with Glitter"
        model_number 'SL-SL'
      end

      factory :blue_slipper do
        name "Red Slipper"
        description "Red Slipper with Glitter"
      end

      factory :blue_sliper_with_variants do
        name "Sliper"
        description "Elegant black high-heeled shoe for executives"
        sequence :model_number do |n|
          "CSH02#{n}"
        end
        after(:create) do |product|
          product.variants << FactoryGirl.create(:basic_shoe_size_35)
          product.variants << FactoryGirl.create(:basic_shoe_size_37)
          product.variants << FactoryGirl.create(:basic_shoe_size_39)
          product.variants << FactoryGirl.create(:basic_shoe_size_40)
        end
      end

      factory :blue_sliper_with_two_variants do
        name "Sliper"
        description "Elegant black high-heeled shoe for executives"
        sequence :model_number do |n|
          "CSH02A#{n}"
        end
        after(:create) do |product|
          product.variants << FactoryGirl.create(:basic_shoe_size_35, number: '35AB')
          product.variants << FactoryGirl.create(:basic_shoe_size_37, number: '37AB')
        end
      end
    end

    factory :bag do
      name "Bagelle"
      description "Elegant black bag for executives"
      category Category::BAG
      sequence :model_number do |n|
        "BG01#{n}"
      end

      factory :basic_bag do
      end

      trait :in_stock do
        after(:create) do |product|
          product.variants << FactoryGirl.create(:basic_bag_simple, :in_stock)
        end
      end

      factory :basic_bag_with_variant do
        sequence :model_number do |n|
          "BG01A#{n}"
        end
        after(:create) do |product|
          product.variants << FactoryGirl.create(:basic_bag_simple, number: 'UNIQAB')
        end
      end
    end

    factory :basic_accessory do
      name "Jewelle"
      description "Elegant jewel for executives"
      category Category::ACCESSORY
      sequence :model_number do |n|
        "JW01#{n}"
      end

      trait :in_stock do
        after(:create) do |product|
          product.variants << FactoryGirl.create(:basic_accessory_simple, :in_stock)
        end
      end
    end

    factory :simple_garment do
      name "Simple T-shirt"
      description "Simple T-shirt"
      category Category::CLOTH

      sequence :model_number do |n|
        "TS01#{n}"
      end

      trait :in_stock do
        after(:create) do |product|
          product.variants << FactoryGirl.create(:yellow_shirt, :in_stock)
        end
      end

    end
  end
end
