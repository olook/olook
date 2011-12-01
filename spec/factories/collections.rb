# -*- encoding : utf-8 -*-
FactoryGirl.define do
  factory :collection do
    name 'Dezembro 2011'
    start_date Date.civil(2011, 11, 20)
    end_date Date.civil(2011, 12, 31)
  end
end
