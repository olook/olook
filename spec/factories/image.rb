# -*- encoding : utf-8 -*-
FactoryGirl.define do
  factory :image do
    image {"PIC_#{Random.rand 1000}"}
    association :lookbook, :factory => :basic_lookbook

    after_build do |image|
      CloudfrontInvalidator.stub_chain(:new, :invalidate)
    end
  end
end

