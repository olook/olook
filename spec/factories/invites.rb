# -*- encoding : utf-8 -*-
FactoryGirl.define do
  factory :invite do
    association :user, :factory => :member
    sequence(:email) {|n| "invite#{n}@friend.com" }
    
    factory :sent_invite do
      sent_at { Time.parse '2011-10-10 18:00' }
    end

    factory :resubmitted_invite do
      resubmitted { nil }
    end
  end
end
