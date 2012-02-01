# -*- encoding : utf-8 -*-
FactoryGirl.define do
  factory :admin do
    first_name "Bloody"
    last_name "Killer"
    password "123456"
    password_confirmation "123456"
    sequence :email do |n|
      "admin#{n}@example.com"
    end
    association :role, :factory => :generic_model
  end

   factory :admin_superadministrator, :parent => :admin do
      association :role, :factory => :superadministrator
   end  

   factory :admin_sac_operator, :parent => :admin do
     association :role, :factory => :sac_operator
   end
end
