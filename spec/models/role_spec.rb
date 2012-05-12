# -*- encoding : utf-8 -*-
require 'spec_helper'

describe Role do


  let(:sac_operator) { FactoryGirl.create(:sac_operator) }
    let(:permissions_hash) do
       {
         "0"=>{"enabled"=>"1", "id"=>sac_operator.permissions[0].id},
         "1"=>{"enabled"=>"1", "id"=>sac_operator.permissions[1].id},
         "2"=>{"enabled"=>"0", "id"=>sac_operator.permissions[2].id}
        }
    end

  it "should receive params with permissions and return permissions" do
    permission_map_builder = FactoryGirl.build(:permission_map_builder, :permissions => sac_operator.permissions)
    permission_map_builder.stub(:map).with(permissions_hash).and_return([])
  end

  it "should check if it has permissions associated" do
    sac_operator.has_permission?(sac_operator.permissions[0].id).should eq(true)
  end

end
