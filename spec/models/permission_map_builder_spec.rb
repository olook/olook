# -*- encoding : utf-8 -*-
require 'spec_helper'

describe PermissionMapBuilder do

  
  let(:collection_index) { FactoryGirl.create(:collection_index) }
  let(:collection_show) { FactoryGirl.create(:collection_show) }
  let(:collection_update) { FactoryGirl.create(:collection_update) }
  let(:permissions_hash) do
    {
      "0"=>{"enabled"=>"1", "id"=>collection_index.id}, 
      "1"=>{"enabled"=>"1", "id"=>collection_show.id}, 
      "2"=>{"enabled"=>"0", "id"=>collection_update.id}
    }
  end

  it "should receive permission attributes and map a hash with permission id as key and state as value" do
    expected = [collection_index, collection_show]
    FactoryGirl.build(:permission_map_builder,
                      :permissions => [collection_index, collection_update]).map(permissions_hash).should == expected
  end

end
