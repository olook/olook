# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :clearsale_order_response do
    order nil
    status "MyString"
    score "9.99"
  end
end
