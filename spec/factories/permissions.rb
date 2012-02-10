# -*- encoding : utf-8 -*-
FactoryGirl.define do
    factory :permission do
      model_name "Collection"
    end  
    factory :collection_index, :parent => :permission do
      action_name "index"
    end  
    factory :collection_show, :parent => :permission do
      action_name "show"
    end 
    factory :collection_destroy, :parent => :permission do
      action_name "destroy"
    end 
    factory :collection_edit, :parent => :permission do
      action_name "edit"
    end
    factory :collection_create, :parent => :permission do
      action_name "create"
    end
    factory :collection_update, :parent => :permission do
      action_name "update"
    end
    factory :permission_map_builder do
      permissions = []
    end   
end
