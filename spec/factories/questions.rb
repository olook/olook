# -*- encoding : utf-8 -*-
FactoryGirl.define do
  factory :question do
    title "Question Title"
    association :survey, :factory => :survey
  end
  
  factory :gift_question, :class => Question do
    title "Question Title"    
    association :survey, :factory => :gift_survey
  end
end
