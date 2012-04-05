# -*- encoding : utf-8 -*-
FactoryGirl.define do
  factory :question do
    title "Question Title"
    association :survey, :factory => :survey
  end
end
