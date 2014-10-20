# -*- encoding : utf-8 -*-
# Read about factories at https://github.com/thoughtbot/factory_girl
FactoryGirl.define do
  factory :highlight do
    
    link "http://www.olook.com.br"
    title "asdasdasd"
    start_date Date.today
    end_date Date.today
    subtitle 'shiusdhidsuhsd'
    alt_text "jsdsdihdsiuhd"

    trait :position_1 do
      image { fixture_file_upload("#{Rails.root}/spec/fixtures/files/shoe02.jpg", "image/jpeg") }
      position 1
      active true
    end

    trait :position_2 do
      left_image { fixture_file_upload("#{Rails.root}/spec/fixtures/files/shoe02.jpg", "image/jpeg") }
      position 2
      active true
    end

    trait :position_3 do
      right_image { fixture_file_upload("#{Rails.root}/spec/fixtures/files/shoe02.jpg", "image/jpeg") }
      position 3
      active true
    end

    trait :default do
      left_image { fixture_file_upload("#{Rails.root}/spec/fixtures/files/shoe02.jpg", "image/jpeg") }
      position 2
      start_date "2012-1-1"
      end_date "2012-1-1"
      default true
    end

    trait :out_of_range do
      left_image { fixture_file_upload("#{Rails.root}/spec/fixtures/files/shoe02.jpg", "image/jpeg") }
      position 2
      start_date "2012-1-1"
      end_date "2012-1-1"
      
    end

  end
end

