# -*- encoding : utf-8 -*-
FactoryGirl.define do
  factory :moment do
    name "dia-a-dia"
    slug "dia-a-dia"
    article "a"
    position 1
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
    article "a"
    position 2
  end
end
