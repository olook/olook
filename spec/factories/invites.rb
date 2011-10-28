FactoryGirl.define do
  factory :invite do
    association :user, :factory => :member
    email "invite@friend.com"
    
    factory :sent_invite do
      sent_at { Time.parse '2011-10-10 18:00' }
    end
  end
end
