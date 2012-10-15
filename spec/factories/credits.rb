# -*- encoding : utf-8 -*-
FactoryGirl.define do
  factory :credit do
    value 12.34
    total 12.34
  end

  factory :credit_to_expire, :class => "Credit" do
  	value 20.00
  	total 20.00
  	expires_at 1.day.from_now
  end
end