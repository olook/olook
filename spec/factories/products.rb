FactoryGirl.define do
  factory :product do
    factory :basic_shoe do
      name "Chanelle"
      description "Elegant black high-heeled shoe for executives"
      category Category::SHOE
    end

    factory :basic_bag do
      name "Bagelle"
      description "Elegant black bag for executives"
      category Category::BAG
    end

    factory :basic_jewel do
      name "Jewelle"
      description "Elegant jewel for executives"
      category Category::JEWEL
    end
  end
end
