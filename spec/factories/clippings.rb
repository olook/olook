FactoryGirl.define do
  factory :clipping do
    logo { fixture_file_upload("#{Rails.root}/spec/fixtures/files/shoe02.jpg", "image/jpeg") }
    title "Olook is awesome"
    clipping_text "Olook is a great online store"
    source "nyt.com"
    published_at { Time.zone.now - 1.day }
      trait :with_link do
        link "nyt.com/olook-is-awesome"
      end
      trait :with_pdf do
        pdf_file { fixture_file_upload("#{Rails.root}/spec/fixtures/files/shoe02.pdf", "file/pdf") }
      end
  end
end
