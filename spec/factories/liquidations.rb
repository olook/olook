# -*- encoding : utf-8 -*-
FactoryGirl.define do
  factory :liquidation do
    name "olooklet"
    description "description"
    starts_at Date.yesterday
    ends_at Date.tomorrow
  end
end
