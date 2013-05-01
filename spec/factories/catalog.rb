# -*- encoding : utf-8 -*-
FactoryGirl.define do
  factory :catalog_product, class: Catalog::Product do
    product { variant.product }
    category_id Category::SHOE
    subcategory_name 'rasteira'
    subcategory_name_label 'Rasteira'
    shoe_size '33'
    shoe_size_label '33'
    heel '0-cm'
    heel_label '0 cm'
    original_price 69.9
    retail_price 69.9
    discount_percent 0
    variant { association :variant }
    inventory 10
    cloth_size nil
  end
end

