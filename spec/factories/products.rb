# -*- encoding : utf-8 -*-
FactoryGirl.define do
  factory :product do
    is_visible true

    factory :basic_shoe do
      name "Chanelle"
      description "Elegant black high-heeled shoe for executives"
      category Category::SHOE
      model_number { "CHS01#{Random.rand 10000}" }
      after_create do |product|
        product.profiles << FactoryGirl.create(:casual_profile)
      end
    end

    factory :basic_bag do
      name "Bagelle"
      description "Elegant black bag for executives"
      category Category::BAG
      model_number 'BGB01'
    end

    factory :basic_accessory do
      name "Jewelle"
      description "Elegant jewel for executives"
      category Category::ACCESSORY
      model_number 'JWJ01'
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
  end
end
