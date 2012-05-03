# -*- encoding : utf-8 -*-
FactoryGirl.define do
  factory :gift_recipient do
    association :user, :factory => :user
    association :gift_recipient_relation, :factory => :gift_recipient_relation
    
    name "Jane Doe"
    shoe_size 36
    facebook_uid '123'
  end
  
end