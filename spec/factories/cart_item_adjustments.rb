# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :cart_item_adjustment do
    value "9.99"
    cart_item_id 1
    source "MyString"
  end
end
