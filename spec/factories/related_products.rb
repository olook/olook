# -*- encoding : utf-8 -*-
FactoryGirl.define do
  factory :related_product do
    association :product_a, :factory => :red_slipper
    association :product_b, :factory => :silver_slipper
  end
end
