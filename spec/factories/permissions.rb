# -*- encoding : utf-8 -*-
FactoryGirl.define do
  factory :permission do
    factory :permission_for_collection do
      model_name "Collection"
      factory :collection_index do
        action_name "index"
      end  
      factory :collection_show do
        action_name "show"
      end 
      factory :collection_destroy do
        action_name "destroy"
      end 
      factory :collection_update do
        action_name "update"
      end
      factory :collection_create do
        action_name "create"
      end
    end   
  end    
end
