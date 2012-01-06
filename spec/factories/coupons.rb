# -*- encoding : utf-8 -*-
FactoryGirl.define do
  factory :coupon do
    factory :standard_coupon do
      code 'FOOBAR000'
      value 50.00
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
  end
end
