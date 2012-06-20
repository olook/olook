# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :campaing_participant do
    first_name "fulano"
    last_name "beltrano"
    email "fulano@beltrano.com"
    gender false
    campaing "marcos_proenca"
  end
end
