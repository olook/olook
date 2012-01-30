# -*- encoding : utf-8 -*-
FactoryGirl.define do
  factory :admin do
    #roles "superadministrator"
    password "123456"
    password_confirmation "123456"
    sequence :email do |n|
      "admin#{n}@example.com"
    end
    after_create do |admin|
      admin.roles << FactoryGirl.create(:superadministrator)
    end

    factory :stylist do
      #role "stylist"
      password "123456"
      password_confirmation "123456"
      sequence :email do |n|
        "admin#{n}@example.com"
      end
    end
  end
end
