# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :action_parameter do
    action_params({ param: "20" })
  end
end
