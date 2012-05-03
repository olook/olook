# -*- encoding : utf-8 -*-
FactoryGirl.define do
  factory :liquidation_product do
    association :liquidation
    association :product, :factory => :basic_shoe
    association :variant, :factory => :basic_bag_simple
    discount_percent 10
    retail_price 30
    inventory 3
    category_id Category::SHOE
  end
end
