# -*- encoding : utf-8 -*-
FactoryGirl.define do
  factory :lookbook do

    factory :basic_lookbook do
      name "Basic_Lookbook"
    end

    factory :complex_lookbook do
      name "Complex_Lookbook"
      after_create do |lookbook|
        lookbook.products << FactoryGirl.create(:basic_shoe)
      end
    end

  end
end
