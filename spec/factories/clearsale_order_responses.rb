# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :clearsale_order_response do
    association :order, :factory => :clean_order
    score "9.99"
    processed false
  end
end
