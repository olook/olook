# -*- encoding : utf-8 -*-
FactoryGirl.define do
  factory :cart_item, :class => CartItem do
    association :variant, factory: :basic_shoe_size_35, inventory: 10
    quantity 2
  end

  factory :cart_item_2, :class => CartItem do
    association :variant, factory: :basic_shoe_size_37, inventory: 5
    quantity 3
  end

  factory :cart_item_3, :class => CartItem do
    association :variant, factory: :basic_bag_simple, inventory: 10
    quantity 1
  end

  factory :cart_item_discount, :class => CartItem do
    association :variant, factory: :basic_shoe_size_37_with_discount, inventory: 10
    quantity 1
  end
  
  factory :cart_item_that_belongs_to_a_cart, :class => CartItem do
    association :variant, factory: :basic_shoe_size_37, inventory: 5
    association :cart, factory: :clean_cart 
    quantity 3
  end
  
end
