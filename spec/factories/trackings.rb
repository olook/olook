# -*- encoding : utf-8 -*-
FactoryGirl.define do
  factory :tracking do
    utm_source "facebook"
    utm_medium "midias"
    utm_content "sociais"
    utm_campaign "42"

    factory :google_tracking do
      gclid "xyz1234556"
      placement "youtube"
      utm_content nil
    end

  end
end
