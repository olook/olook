# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :user_coupon do
    user nil

    trait :with_nil_coupon_ids do
      coupon_ids nil
    end

    trait :with_empty_coupon_ids do
      coupon_ids ""
    end
    
    trait :with_coupon_ids do
      coupon_ids "1,4,5"
    end
  end
end
