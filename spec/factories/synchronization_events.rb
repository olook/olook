# -*- encoding : utf-8 -*-
FactoryGirl.define do
  factory :synchronization_event do
    factory :locked_synchronization_event do
      name "products"
    end

    factory :unlocked_synchronization_event do
      name "inventory"
      created_at 25.minutes.ago
    end

    factory :weird_name_synchronization_event do
      name "alkjh"
    end
  end
end
