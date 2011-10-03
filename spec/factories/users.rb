FactoryGirl.define do
  factory :user do
    password "123456"
    password_confirmation "123456"
    email "user@mail.com"
    first_name "User First Name"
    last_name "User Last Name"

    factory :member do
      email "member@mail.com"
      first_name "First Name"
      last_name "Last Name"

      after_create do |member|
        member.send(:write_attribute, :invite_token, 'OK'*10)
        member.save!
      end
    end
  end
end
