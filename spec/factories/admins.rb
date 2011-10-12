# -*- encoding : utf-8 -*-
FactoryGirl.define do
  factory :admin do
    password "123456"
    password_confirmation "123456"
    sequence :email do |n|
      "admin#{n}@example.com"
    end
  end
end
