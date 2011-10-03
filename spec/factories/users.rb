FactoryGirl.define do
  factory :user do
    password "123456"
    password_confirmation "123456"
    email "user@mail.com"
    first_name "User First Name"
    last_name "User Last Name"
  end
end
