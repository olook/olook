# -*- encoding : utf-8 -*-
FactoryGirl.define do
  factory :answer do
    association :question
    title "Answer Title"

    factory :answer_from_casual_profile do
      title "Casual Answer Title"
    end

    factory :answer_from_sporty_profile do
      title "Sporty Answer Title"
    end
  end
end
