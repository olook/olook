# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :campaign do
    start_at "2012-11-13"
    end_at "2012-11-13"
    lightbox "MyString"
    banner "MyString"
    background "MyString"
  end
end
