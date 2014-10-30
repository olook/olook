# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :credit_payment do
    total_paid 12.34
    association :credit_type, :factory => :redeem_credit_type
  end

end
