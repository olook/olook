# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :promotion_free_item, class: FreeItem do
    name "FreeItem"
    type "FreeItem"
  end
end
