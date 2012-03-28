# -*- encoding : utf-8 -*-
FactoryGirl.define do
  factory :user_info do
    association :user, :factory => :user
    shoes_size 35
  end
end
