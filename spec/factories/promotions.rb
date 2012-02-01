# -*- encoding : utf-8 -*-
FactoryGirl.define do
  factory :first_time_buyers, :class => Promotion do
    name "First time buyers"
    strategy "purchases_amount_strategy"
    priority 1
    discount_percent 30
    params :amount => 0
    active true
  end
end

