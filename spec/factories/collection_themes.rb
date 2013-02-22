# -*- encoding : utf-8 -*-
FactoryGirl.define do
  factory :collection_theme do
    name "dia-a-dia"
    slug "dia-a-dia"
    article "Para a"
    position 1
    active true
  end

  factory :collection_themes, :class => CollectionTheme do
    sequence :name do |n|
      "moment#{n}"
    end
    sequence :slug do |n|
      "moment#{n}"
    end
    active true
    article "Para a"
    position 2
  end
end
