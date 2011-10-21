# -*- encoding : utf-8 -*-
FactoryGirl.define do
  factory :picture do
    factory :gallery_picture do
      image "aa"
      display_on DisplayPictureOn::GALLERY_1
      association :product, :factory => :basic_shoe
    end
  end
end
