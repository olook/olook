# -*- encoding : utf-8 -*-
FactoryGirl.define do
  factory :user do
    uid "abc"
    password "123456"
    password_confirmation "123456"
    sequence :email do |n|
      "person#{n}@example.com"
    end
    first_name "José"
    last_name "Ernesto"
    facebook_permissions []
    half_user false
    created_at 2.days.ago

    trait :with_user_info do
      user_info
    end

    factory :member do
      sequence :email do |n|
      "member#{n}@example.com"
      end
      first_name "First Name"
      last_name "Last Name"
      is_invited nil
      cpf nil

      after(:create) do |member|
        member.send(:write_attribute, :invite_token, 'OK'*4)
        member.save!
      end
    end
  end

  factory :db_user do
    uid "abc"
    password "123456"
    password_confirmation "123456"
    sequence :email do |n|
      "person#{n}@example.com"
    end
    first_name "User First Name"
    last_name "User Last Name"
    half_user false
  end
end
