# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :user_credit do
    credit_type nil
    user nil
    total "9.99"
  end
end
