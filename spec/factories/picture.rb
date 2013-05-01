# -*- encoding : utf-8 -*-
FactoryGirl.define do
  factory :picture do
    image { fixture_file_upload("#{Rails.root}/spec/fixtures/files/shoe02.jpg", "image/jpeg") }
    association :product, :factory => [:shoe, :casual]

    factory :main_picture do
      image { fixture_file_upload("#{Rails.root}/spec/fixtures/files/shoe02.jpg", "image/jpeg") }
      display_on DisplayPictureOn::GALLERY_1
    end

    after(:build) do |picture|
      CloudfrontInvalidator.stub_chain(:new, :invalidate)
    end
  end
end

