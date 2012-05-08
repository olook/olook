# -*- encoding : utf-8 -*-
FactoryGirl.define do

  factory :survey do
    name "Registration Survey"
  end

  factory :gift_survey, :class => Survey do
    name "Gift Survey"
  end
end