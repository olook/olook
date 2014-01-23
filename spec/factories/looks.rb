FactoryGirl.define do
  factory :look do
    product_id 1
    sequence :picture do |n|
      "image#{n}"
    end
    launched_at "2014-01-20 19:14:43"
    profile_id 1
  end
end
