# -*- encoding : utf-8 -*-
FactoryGirl.define do
  factory :clean_cart, :class => Cart do

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

    factory :cart_with_3_items do
      after_create do |cart|
        FactoryGirl.create(:cart_item, :cart => cart)
        FactoryGirl.create(:cart_item_2, :cart => cart)
        FactoryGirl.create(:cart_item_3, :cart => cart)
      end
    end

  end
end
