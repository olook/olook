FactoryGirl.define do
  factory :user do
    password "123456"
    password_confirmation "123456"
    email "user@mail.com"
    name "User First Name"
    
    factory :member do
      name "Member Jane Doe"
      email "member.jane@mail.com"
    end
  end
end
