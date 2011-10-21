# -*- encoding : utf-8 -*-
FactoryGirl.define do
  factory :detail do
    factory :heel_detail do
      association :product, :factory => :basic_shoe
      display_on DisplayDetailOn::DETAILS
      description "High heel"
      translation_token 'heel'
    end
    factory :invisible_detail do
      association :product, :factory => :basic_shoe
      display_on DisplayDetailOn::INVISIBLE
      description "Meta data used for data mining"
      translation_token 'meta_data'
    end
  end
end
