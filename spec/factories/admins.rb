# -*- encoding : utf-8 -*-
FactoryGirl.define do
  factory :admin do
    password "123456"
    password_confirmation "123456"
    sequence :email do |n|
      "admin#{n}@example.com"
    end
    factory :admin_superadministrator do
      after_create do |admin|
        admin.roles << FactoryGirl.create(:superadministrator)
      end
    end  

    factory :admin_sac_operator do
      after_create do |admin|
        admin.roles << FactoryGirl.create(:sac_operator)
      end 
    end
  end
end
