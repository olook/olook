# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :redeem_credit_payment, class: CreditPayment do
    total_paid 12.34
    association :credit_type, :factory => :redeem_credit_type
  end

  factory :invite_credit_payment, class: CreditPayment do
    total_paid 12.34
    association :credit_type, :factory => :invite_credit_type
  end  

end
