FactoryGirl.define do
  factory :product do
    factory :basic_shoe do
      name "Chanelle"
      description "Elegant black high-heeled shoe for executives"
      category Category::SHOE
      model_number 'CHS01'
    end

    factory :basic_bag do
      name "Bagelle"
      description "Elegant black bag for executives"
      category Category::BAG
      model_number 'BGB01'
    end

    factory :basic_jewel do
      name "Jewelle"
      description "Elegant jewel for executives"
      category Category::JEWEL
      model_number 'JWJ01'
    end
  end
end
