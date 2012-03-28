# -*- encoding : utf-8 -*-
FactoryGirl.define do
	factory :survey_answer do |f|
    f.answers {eval("{:foo => :bar}")}
  end
end

