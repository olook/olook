FactoryGirl.define do
  factory :clipping do
    logo { fixture_file_upload("#{Rails.root}/spec/fixtures/files/shoe02.jpg", "image/jpeg") }
    title "Olook is awesome"
    clipping_text "Olook is a great online store"
    source "nyt.com"
    link "nyt.com/olook-is-awesome"
      trait :published do
        published_at { Time.zone.now - 1.day }
      end
  end
end
