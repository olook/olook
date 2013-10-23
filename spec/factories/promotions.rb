# -*- encoding : utf-8 -*-
FactoryGirl.define do
  factory :first_time_buyers, :class => Promotion do
    association :action_parameter, factory: :action_parameter

    name "first time buyers"
    active true

    factory :second_time_buyers do
      name "second time buyers"
      active true
    end

    factory :compre_3_pague_2 do
      association :action_parameter, factory: :action_parameter
      # association :promotion_action, factory: :percentage_adjustment
      name "compre_3_pague_2"
      active true
    end
    after(:build) do |promotion|
      promotion.rule_parameters.build FactoryGirl.attributes_for(:rule_parameter) #rule_parameters << FactoryGirl.build(:rule_parameter)
    end
  end
end

