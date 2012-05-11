# -*- encoding : utf-8 -*-
FactoryGirl.define do
  factory :moment do
    name "dia-a-dia"
    slug "dia-a-dia"
    active true
  end
  
  factory :moments, :class => Moment do
    sequence :name do |n|
      "moment#{n}"
    end
    sequence :slug do |n|
      "moment#{n}"
    end
    active true
  end
end
