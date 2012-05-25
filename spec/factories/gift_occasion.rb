# -*- encoding : utf-8 -*-
FactoryGirl.define do
  factory :gift_occasion do
    association :user, :factory => :user
    association :gift_recipient, :factory => :gift_recipient
    association :gift_occasion_type, :factory => :gift_occasion_type
    
    day 13
    month 6
  end
end