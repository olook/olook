# -*- encoding : utf-8 -*-
FactoryGirl.define do
  factory :profile do
    name 'Casual'
    first_visit_banner 'casual'
    alternative_name 'casual'

    trait :with_products do
      after(:create) do |profile|
        collection = FactoryGirl.create(:collection)
        profile.products << FactoryGirl.create(:shoe, :in_stock, collection: collection)
        profile.products << FactoryGirl.create(:bag, :in_stock, collection: collection)
        profile.products << FactoryGirl.create(:basic_accessory, :in_stock, collection: collection)
      end
    end

    trait :with_points do
      after(:create) do |profile|
        profile.points << FactoryGirl.create(:point, value: 50)
      end
    end

    trait :with_user do
      after(:create) do |profile|
        profile.users << FactoryGirl.create(:member, :with_user_info)
      end
    end

    factory :casual_profile do
      name "Casual Profile"
      alternative_name "casual"
      first_visit_banner 'casual'
    end

    factory :sporty_profile do
      name "Sporty Profile"
      first_visit_banner 'sporty'
    end
  end
end
