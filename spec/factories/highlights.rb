# -*- encoding : utf-8 -*-
# Read about factories at https://github.com/thoughtbot/factory_girl
FactoryGirl.define do
  factory :highlight do
    image { fixture_file_upload("#{Rails.root}/spec/fixtures/files/shoe02.jpg", "image/jpeg") }
    link "http://www.olook.com.br"
    highlight_type 1
    

    trait :at_position_1 do
      position 1
    end

    trait :at_position_2 do
      position 2
    end

    trait :at_position_3 do
      position 3
    end
  end
end
