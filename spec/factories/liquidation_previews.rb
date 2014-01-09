# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :liquidation_preview do
    product nil
    name "MyString"
    category "MyString"
    subcategory "MyString"
    price "9.99"
    retail_price "9.99"
    discount_percentage "9.99"
    inventory "MyString"
    color "MyString"
    visible false
    visibility 1
    picture_url "MyString"
  end
end
