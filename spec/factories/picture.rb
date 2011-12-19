# -*- encoding : utf-8 -*-
FactoryGirl.define do
  factory :picture do
    image {"PIC_#{Random.rand 1000}"}
    association :product, :factory => :basic_shoe

    factory :main_picture do
      display_on DisplayPictureOn::GALLERY_1
    end

    after_build do |picture|
      CloudfrontInvalidator.stub_chain(:new, :invalidate)
    end
  end
end

