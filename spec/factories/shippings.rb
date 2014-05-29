# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :shipping do
    zip_start "1000000"
    zip_end "3000000"
    cost "9.99"
    delivery_time 5
    income "15.99"
    shipping_service_id 1
  end
end
