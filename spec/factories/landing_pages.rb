# -*- encoding : utf-8 -*-
FactoryGirl.define do
  factory :landing_page do
    sequence(:page_title) {|n| "Page Title #{n}" }
    sequence(:page_url) {|n| "page-url-#{n}" }
  end
end
