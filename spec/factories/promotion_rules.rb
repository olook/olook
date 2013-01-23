# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :promotion_free_item, class: CartItemsAmount do
    name "CartItemsAmount"
    type "CartItemsAmount"
  end
end
