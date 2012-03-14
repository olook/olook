# -*- encoding : utf-8 -*-
FactoryGirl.define do
  factory :liquidation do
    name "olooklet"
    description "D" * 100
    starts_at Date.yesterday
    ends_at Date.tomorrow
  end
end
