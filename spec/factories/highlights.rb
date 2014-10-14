# -*- encoding : utf-8 -*-
# Read about factories at https://github.com/thoughtbot/factory_girl
FactoryGirl.define do
  factory :highlight do
    image { fixture_file_upload("#{Rails.root}/spec/fixtures/files/shoe02.jpg", "image/jpeg") }
    link "http://www.olook.com.br"
    title "asdasdasd"
    start_date Date.today
    end_date Date.today
    subtitle 'shiusdhidsuhsd'
    alt_text "jsdsdihdsiuhd"
    position 1

    trait :active do
      active true
    end

    trait :active_false_default_true do
      active false 
      default true
    end

    trait :out_of_range_active_false do
      start_date "2012-1-1"
      end_date "2012-1-1"
      active false 
      default true
    end

    trait :out_of_range_active_true do
      start_date "2012-1-1"
      end_date "2012-1-1"
      active true 
      default true
    end

    trait :nothing do
      start_date "2012-1-1"
      end_date "2012-1-1"
      active false
      default false
    end

  end
end
