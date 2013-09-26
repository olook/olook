# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :catalog_header do
    url "MyString"
    type ""
    h1 "MyString"
    h2 "MyString"
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
  end
end
