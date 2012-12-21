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

  factory :compre_3_pague_2, :class => Promotion do
    name "compre_3_pague_2"
    strategy "free_item_strategy"
    banner_label "compre_3_pague_2"
    priority 0
    discount_percent 0
    param '3'
    active true
  end
end

