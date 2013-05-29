# -*- encoding : utf-8 -*-
FactoryGirl.define do
  factory :line_item do
    association :variant, :factory => :basic_shoe_size_35
    association :order, :factory => :order
    quantity 2
    price 179.90
    retail_price 179.90
  end

  factory :line_item_loyalty do
    association :variant, :factory => :basic_shoe_size_35
    association :order, :factory => :order
    quantity 1
    price 100.00
    retail_price 100.00
  end
end
