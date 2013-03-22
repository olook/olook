# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :consolidated_sell do
    category "MyString"
    day "2013-03-22"
    amount 1
    total "9.99"
    subcategory "MyString"
    total_retail "9.99"
  end
end
