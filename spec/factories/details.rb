# -*- encoding : utf-8 -*-
FactoryGirl.define do
  factory :detail do
    association :product, :factory => :basic_shoe

    factory :heel_detail do
      display_on DisplayDetailOn::SPECIFICATION
      description "High heel"
      translation_token 'heel'
    end
    factory :invisible_detail do
      display_on DisplayDetailOn::INVISIBLE
      description "Meta data used for data mining"
      translation_token 'meta_data'
    end
    factory :how_to_detail do
      display_on DisplayDetailOn::HOW_TO
      description "How to wear"
      translation_token 'how to'
    end
  end
end
