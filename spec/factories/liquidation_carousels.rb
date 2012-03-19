# -*- encoding : utf-8 -*-
FactoryGirl.define do
  factory :liquidation_carousel do
    association :liquidation, :factory => :liquidation
  end
end
