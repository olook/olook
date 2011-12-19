# -*- encoding : utf-8 -*-
FactoryGirl.define do
  factory :user do
    uid "abc"
    password "123456"
    password_confirmation "123456"
    sequence :email do |n|
      "person#{n}@example.com"
    end
    first_name "User First Name"
    last_name "User Last Name"

    after_build do |user|
      Resque.stub(:enqueue)
    end

    after_create do |user|
      user.record_early_access
    end

    factory :member do
      sequence :email do |n|
      "member#{n}@example.com"
      end
      first_name "First Name"
      last_name "Last Name"

      after_build do |user|
        Resque.stub(:enqueue)
      end

      after_create do |member|
        member.send(:write_attribute, :invite_token, 'OK'*4)
        member.save!
      end
    end
  end
end
