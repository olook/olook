# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :promotion_action do
    type "PercentageAdjustment"
    description "Action for Percentage"
  end
end
