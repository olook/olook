FactoryGirl.define do
  factory :gift_box do
    name "Top 5"
    active true
    thumb_image "image.jpg"

    factory :gift_box_helena do
      name "Dica da Helena"
    end

    factory :gift_box_top_five do
      name "Top Five"
    end


    factory :gift_box_hot_fb do
      name "Hot on Facebook"
    end
  end
end
