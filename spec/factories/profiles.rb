# -*- encoding : utf-8 -*-
FactoryGirl.define do
  factory :profile do
    factory :casual_profile do
      name "Casual Profile"
      first_visit_banner 'casual'
    end

    factory :sporty_profile do
      name "Sporty Profile"
      first_visit_banner 'sporty'
    end
  end
end
