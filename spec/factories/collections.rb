# -*- encoding : utf-8 -*-
FactoryGirl.define do

  factory :collection do
    name 'Dezembro 2011'
    is_active true
    start_date Date.civil(2011, 11, 20)
    end_date Date.civil(2011, 12, 31)

    trait :active do
      name { I18n.l(Time.now, format: '%B') }
      is_active true
      start_date { Time.now.beginning_of_day }
      end_date { 2.days.from_now.end_of_day }
    end

    trait :inactive do
      is_active false
    end

    factory :inactive_collection do
      is_active false
    end

    factory :january_2012_collection do
      name 'Janeiro 2012'
      start_date Date.civil(2012, 01, 01)
      end_date Date.civil(2012, 01, 31)
      is_active false
    end

    factory :february_2012_collection do
      name 'Fevereiro 2012'
      start_date Date.civil(2012, 02, 01)
      end_date Date.civil(2012, 02, 29)
      is_active false
    end

    factory :march_2012_collection do
      name 'Março 2012'
      start_date Date.civil(2012, 03, 01)
      end_date Date.civil(2012, 03, 31)
    end

    factory :active_collection do
      is_active true
    end
  end
end
