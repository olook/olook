# -*- encoding : utf-8 -*-
FactoryGirl.define do
  factory :clean_cart, :class => Cart do

    factory :cart_with_one_item do
      after(:create) do |cart|
        FactoryGirl.create(:cart_item, :quantity => 1, :cart => cart)
      end
    end

    factory :cart_with_items do
      after(:create) do |cart|
        FactoryGirl.create(:cart_item, :cart => cart)
      end
    end

    factory :cart_with_gift do
      after(:create) do |cart|
        FactoryGirl.create(:cart_item, :cart => cart, :gift => true)
      end
    end

    factory :cart_with_3_items do
      after(:create) do |cart|
        FactoryGirl.create(:cart_item, :cart => cart)
        cart.items << FactoryGirl.create(:cart_item_2, :cart => cart)
        cart.items << FactoryGirl.create(:cart_item_3, :cart => cart)
      end
    end

    factory :cart_with_1_full_and_1_discount do
      after(:create) do |cart|
        FactoryGirl.create(:cart_item, :cart => cart)
        cart.items << FactoryGirl.create(:cart_item_discount, :cart => cart)
      end
    end

    factory :cart_with_2_items do
      # after(:create) do |cart|
      #   FactoryGirl.create(:cart_item_2, :cart => cart)
      #   FactoryGirl.create(:cart_item_3, :cart => cart)
      # end
    end

  end
end
