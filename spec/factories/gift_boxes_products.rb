FactoryGirl.define do
  factory :gift_boxes_product do
    factory :gift_box_product_helena do
      association :product, factory: :shoe
    end

    factory :gift_box_product_top_five do
      association :product, factory: :basic_accessory
    end

    factory :gift_box_product_hot_on_fb do
      association :product, factory: :bag
    end
  end
end
