FactoryGirl.define do
  factory :role do
    factory :superadministrator do
      name "superadministrator"
      description "IT manager and developers"
    end

    factory :generic_model do
      name "generic"
      description "dummy role"
    end
    factory :sac_operator do
      name "sac_operator"
      description "SAC operators"
      after_create do |sac_operator|
        sac_operator.permissions = [FactoryGirl.create(:collection_index), 
          FactoryGirl.create(:collection_show), FactoryGirl.create(:collection_edit)
        ]
      end
    end
  end  
end