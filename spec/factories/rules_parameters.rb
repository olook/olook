# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :rule_parameter do
    association :promotion, factory: :compre_3_pague_2
    rules_params "3"
    promotion_id 1
  end
end
