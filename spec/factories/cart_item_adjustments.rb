# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :cart_item_adjustment do
    association :cart_item, factory: :cart_item_that_belongs_to_a_cart
    value "9.99"
    cart_item_id 1
    source "MyString"
  end
end
