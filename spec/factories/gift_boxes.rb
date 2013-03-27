FactoryGirl.define do
  factory :gift_box do
    name "Top 5"
    active true
    #thumb_image "image.jpg"
    thumb_image { fixture_file_upload("#{Rails.root}/spec/fixtures/files/shoe02.jpg", "image/jpeg") }

    factory :gift_box_helena do
      name "Dica da Helena"
      after(:create) do |gift_box|
        gift_box.gift_boxes_product << FactoryGirl.create(:gift_box_product_helena)
      end
    end

    factory :gift_box_top_five do
      name "Top Five"
      after(:create) do |gift_box|
        gift_box.gift_boxes_product << FactoryGirl.create(:gift_box_product_top_five)
      end
    end


    factory :gift_box_hot_fb do
      name "Hot on Facebook"
      after(:create) do |gift_box|
        gift_box.gift_boxes_product << FactoryGirl.create(:gift_box_product_hot_on_fb)
      end
    end
  end
end
