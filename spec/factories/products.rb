FactoryGirl.define do
  factory :product do
    factory :basic_shoe do
      name "Chanelle"
      description "Elegant black high-heeled shoe for executives"
      category :shoe
    end

    factory :basic_bag do
      name "Bagelle"
      description "Elegant black bag for executives"
      category :bag
    end

    factory :basic_jewel do
      name "Jewelle"
      description "Elegant jewel for executives"
      category :jewel
    end
  end
end
