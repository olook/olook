# -*- encoding : utf-8 -*-
FactoryGirl.define do
  factory :product do
    is_visible true

    factory :basic_shoe do
      name "Chanelle"
      description "Elegant black high-heeled shoe for executives"
      category Category::SHOE
      sequence :model_number do |n|
        "CSH01#{n}"
      end
      after_create do |product|
        product.profiles << FactoryGirl.create(:casual_profile)
      end
    end

    factory :basic_bag do
      name "Bagelle"
      description "Elegant black bag for executives"
      category Category::BAG
      sequence :model_number do |n|
        "BG01#{n}"
      end
    end

    factory :basic_accessory do
      name "Jewelle"
      description "Elegant jewel for executives"
      category Category::ACCESSORY
      sequence :model_number do |n|
        "JW01#{n}"
      end
    end

    factory :red_slipper do
      name "Red Slipper"
      description "Red Slipper with Glitter"
      category Category::SHOE
      model_number 'SL-RD'
    end

    factory :silver_slipper do
      name "Silver Slipper"
      description "Silver Slipper with Glitter"
      category Category::SHOE
      model_number 'SL-SL'
    end

    factory :blue_slipper do
      name "Red Slipper"
      description "Red Slipper with Glitter"
      category Category::SHOE
      sequence :model_number do |n|
        "CSH01#{n}"
      end
    end

    factory :blue_sliper_with_variants do
      name "Sliper"
      description "Elegant black high-heeled shoe for executives"
      category Category::SHOE
      is_visible true
      sequence :model_number do |n|
        "CSH02#{n}"
      end
      after_create do |product|
        product.variants << FactoryGirl.create(:basic_shoe_size_35)
        product.variants << FactoryGirl.create(:basic_shoe_size_37)
        product.variants << FactoryGirl.create(:basic_shoe_size_39)
        product.variants << FactoryGirl.create(:basic_shoe_size_40)
      end
    end


    factory :blue_sliper_with_two_variants do
      name "Sliper"
      description "Elegant black high-heeled shoe for executives"
      category Category::SHOE
      is_visible true
      sequence :model_number do |n|
        "CSH02A#{n}"
      end
      after_create do |product|
        product.variants << FactoryGirl.create(:basic_shoe_size_35, number: '35AB')
        product.variants << FactoryGirl.create(:basic_shoe_size_37, number: '37AB')
      end
    end
  end
end
