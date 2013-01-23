# -*- encoding : utf-8 -*-
FactoryGirl.define do
  factory :first_time_buyers, :class => Promotion do
    association :action_parameter, factory: :action_parameter
    association :promotion_action, factory: :percentage_adjustment
    name "first time buyers"
    banner_label "desconto de primeira compra"
    active true
  end

  factory :second_time_buyers, :class => Promotion do
    name "second time buyers"
    banner_label "desconto de segunda compra"
    active true
  end

  factory :compre_3_pague_2, :class => Promotion do
    name "compre_3_pague_2"
    banner_label "compre_3_pague_2"
    active true
  end
end

