# -*- encoding : utf-8 -*-
FactoryGirl.define do
  factory :detail do
    factory :heel_detail do
      association :product, :factory => :basic_shoe
      display_on DisplayDetailOn::DETAILS
      description "High heel"
      translation_token 'heel'
    end
  end
end
