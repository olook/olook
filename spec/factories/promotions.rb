# -*- encoding : utf-8 -*-
FactoryGirl.define do
  factory :first_time_buyers, :class => Promotion do
    name "first time buyers"
    strategy "purchases_amount_strategy"
    banner_label "desconto de primeira compra"
    priority 1
    discount_percent 30
    param '0'
    active true
  end

  factory :second_time_buyers, :class => Promotion do
    name "second time buyers"
    strategy "purchases_amount_strategy"
    banner_label "desconto de segunda compra"
    priority 2
    discount_percent 50
    param '0'
    active true
  end
end

