# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :shipping_policy do
    zip_start "MyString"
    zip_end "MyString"
    value_start "MyString"
    value_end "MyString"
  end
end
