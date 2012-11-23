# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :gift_boxes_product, :class => 'GiftBoxesProducts' do
    gift_box_id "MyString"
    product_id "MyString"
  end
end
