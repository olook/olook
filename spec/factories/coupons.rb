# -*- encoding : utf-8 -*-
FactoryGirl.define do
  factory :coupon do
    campaign 'Flyer'
    created_by 'John Doe'
    updated_by 'John Doe'
    factory :standard_coupon do
      sequence :code do |n|
        "STD#{n}"
      end
      remaining_amount 1
      start_date Time.now
      end_date Time.now + 50.days
      active true
    end

    factory :expired_coupon do
      code 'FOOBAR010'
      value 50.00
      remaining_amount 1
      start_date 6.days.ago
      end_date 2.days.ago
      active true
    end

    factory :not_available_coupon do
      code 'FOOBAR010'
      value 50.00
      remaining_amount 1
      start_date 6.days.ago
      end_date 2.days.from_now
      active false
    end

    factory :unavailable_coupon do
      code 'FOOBAR010'
      value 50.00
      remaining_amount 1
      start_date 6.days.ago
      end_date 25.years.from_now
      active false
    end

    factory :unlimited_coupon do
      code 'FOOBAR001'
      value 50.00
      remaining_amount nil
      start_date Time.now
      end_date Time.now + 50.days
      active true
      unlimited true
    end

    factory :limited_coupon do
      code 'FOOBAR002'
      value 50.00
      remaining_amount 1
      start_date Time.now
      end_date Time.now + 50.days
      active true
    end

    factory :product_coupon do
      code 'PRODUCT_COUPON1'
      value 20.00
      remaining_amount 1
      start_date Time.now
      end_date Time.now + 50.days
      active true
      is_percentage true
    end

    factory :brand_coupon do
      code 'BRAND_COUPON1'
      brand 'OLOOK'
      value 20.00
      remaining_amount 1
      start_date Time.now
      end_date Time.now + 50.days
      active true
      is_percentage true
    end
  end
end
