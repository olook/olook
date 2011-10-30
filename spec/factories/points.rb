# -*- encoding : utf-8 -*-
FactoryGirl.define do
  factory :point do
    association :user, :factory => :member
    association :profile, :factory => :casual_profile
    value 10
  end
end
