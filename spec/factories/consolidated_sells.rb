# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :consolidated_sell do
    category "1"
    day { Date.new(2013, 03, 22) }
    amount 1
    total { BigDecimal.new "9.99" }
    subcategory "Anabela"
    total_retail { BigDecimal.new "9.99" }
  end
end
