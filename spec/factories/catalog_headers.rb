# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :catalog_header, :class => CatalogHeader::CatalogBase  do
    url "/sapato"
    type ""
    seo_text "Sapatos"
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
    text_complement "MyText"
    organic_url "/sapatos"
    product_list "1001,1002,1003"

    trait :text do
      type "CatalogHeader::TextCatalogHeader"
    end
    trait :big_banner do
      type "CatalogHeader::BigBannerCatalogHeader"
    end
    trait :small_banner do
      type "CatalogHeader::SmallBannerCatalogHeader"
    end
    trait :mkt do
      type "CatalogHeader::CustomUrlCatalogHeader"
    end
  end
end
