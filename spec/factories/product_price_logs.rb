# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :product_price_log do
    product_id 1
    price "9.99"
    retail_price "9.99"
  end
end
