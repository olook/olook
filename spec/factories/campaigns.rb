# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :campaign do
    id "123"
    title "First Campaign"
    start_at "2012-11-10"
    end_at "2012-11-15"
    banner "path_to_image"
    background "#FFF"
    description "some description"

    factory :second_campaign do
      id "456"
      title "Another Campaign"
    end
  end
end
