# -*- encoding : utf-8 -*-
FactoryGirl.define do
  factory :unlockedsyncevent do
    name "products"
  end

  factory :lockedsyncevent do
    name "products"
    created_at 15.minutes.ago
  end
end
