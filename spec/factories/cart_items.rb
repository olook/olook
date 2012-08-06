# -*- encoding : utf-8 -*-
FactoryGirl.define do
  factory :cart_item, :class => CartItem do
    association :variant, factory: :basic_shoe_size_35, inventory: 10
    quantity 2
  end
end
