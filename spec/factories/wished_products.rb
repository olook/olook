# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :wished_product do
    variant_id 1
    wishlist_id 1
    retail_price "9.99"
  end
end
