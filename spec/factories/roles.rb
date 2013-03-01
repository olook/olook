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
      after(:create) do |sac_operator|
        sac_operator.permissions = [FactoryGirl.create(:collection_index),
          FactoryGirl.create(:collection_show), FactoryGirl.create(:collection_edit)
        ]
      end
    end

    factory :business1 do
      name "business1"
      description "Business 1 users"
      after(:create) do |user|
        user.permissions = [FactoryGirl.create(:collection_index),
          FactoryGirl.create(:collection_show), FactoryGirl.create(:collection_edit),
          FactoryGirl.create(:collection_update), FactoryGirl.create(:collection_destroy)
        ]
      end
    end
  end
end
