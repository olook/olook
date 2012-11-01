# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :braspag_callback do
    order_id "MyString"
    status "MyString"
    payment 1
  end
end
