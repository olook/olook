# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :campaign do
    title "First Campaign"
    start_at "2012-11-13"
    end_at "2012-11-13"
    lightbox "path_to_image"
    banner "path_to_image"
    background "#FFF"
    description "some description"

    factory :second_campaign do
      title "Another Campaign"
      start_at "2012-12-13"
      end_at "2012-12-13"
    end
  end
end
