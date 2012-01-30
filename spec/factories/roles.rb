FactoryGirl.define do
  factory :role do
    factory :superadministrator do
      name "superadministrator"
      description "IT manager and developers"
    end
    factory :sac_operator do
      name "sac_operator"
      description "SAC operators"
    end
  end  
end