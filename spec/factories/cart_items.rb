# -*- encoding : utf-8 -*-
FactoryGirl.define do
  factory :cart_item, :class => CartItem do
    association :variant, :factory => :variant
    discount_source ''
    quantity 2
    price 179.90
  end
end
