# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :rules_parameter do
    params "MyText"
    promotion_rule_id 1
    promotion_id 1
  end
end
