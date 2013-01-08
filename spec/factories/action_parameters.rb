# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :action_parameter do
    promotion_id 1
    promotion_action_id 1
    param "MyString"
  end
end
