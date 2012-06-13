# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :lookbook_image_map do
    lookbook nil
    image nil
    product nil
    coord_x 1
    coord_y 1
  end
end
