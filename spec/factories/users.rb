FactoryGirl.define do
  factory :user do
    password "123456"
    password_confirmation "123456"
    email "user@mail.com"
    name "User First Name"
  end
end
