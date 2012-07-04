# -*- encoding : utf-8 -*-
FactoryGirl.define do
  factory :clean_cart, :class => Cart do

    factory :cart_with_items do
      after_create do |cart|
        FactoryGirl.create(:cart_item, :cart => cart)
      end
    end

  end
end
