# -*- encoding : utf-8 -*-
FactoryGirl.define do
  factory :clean_cart, :class => Cart do

    factory :cart_with_one_item do
      after_create do |cart|
        FactoryGirl.create(:cart_item, :quantity => 1, :cart => cart)
      end
    end

    factory :cart_with_items do
      after_create do |cart|
        FactoryGirl.create(:cart_item, :cart => cart)
      end
    end
    
    factory :cart_with_gift do
      after_create do |cart|
        FactoryGirl.create(:cart_item, :cart => cart, :gift => true)
      end
    end

  end
end
