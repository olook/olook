# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :shipping do
    carrier "MyString"
    zip_start "MyString"
    zip_end "MyString"
    cost "9.99"
    delivery_time 1
    income "9.99"
  end
end
