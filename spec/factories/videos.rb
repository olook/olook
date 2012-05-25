# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :video do
    title "MyString"
    url "MyString"
    video_relation_id 1
    video_relation_type "MyString"
  end
end
