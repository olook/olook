# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :header do
    sequence :url do |n|
      "/sapatao_#{n}"
    end
    type ""
    page_title "Sapatos"
    page_description "Descricao"
    enabled true
    small_banner1 "MyString"
    alt_small_banner1 "MyString"
    link_small_banner1 "MyString"
    small_banner2 "MyString"
    alt_small_banner2 "MyString"
    link_small_banner2 "MyString"
    medium_banner "MyString"
    alt_medium_banner "MyString"
    link_medium_banner "MyString"
    big_banner "MyString"
    alt_big_banner "MyString"
    link_big_banner "MyString"
    title "MyString"
    resume_title "MyString"
    organic_url "/sapatos"
    product_list "1001,1002,1003"

    trait :text do
      type "TextCatalogHeader"
    end
    trait :big_banner do
      type "BigBannerCatalogHeader"
    end
    trait :small_banner do
      type "SmallBannerCatalogHeader"
    end
    trait :no_banner do
      type "NoBanner"
    end
  end
end
