FactoryGirl.define do
  factory :invite do
    association :user, :factory => :member
    email "invite@friend.com"
  end
end
