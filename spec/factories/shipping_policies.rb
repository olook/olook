# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :shipping_policy do
    zip_start "1000000"
    zip_end "3000000"
    free_shipping 100.00
  end
end
