# -*- encoding : utf-8 -*-
require 'spec_helper'

describe Role do


  let(:sac_operator) { Factory(:sac_operator) }
    let(:permissions_hash) { {"0"=>{"enabled"=>"1", "id"=>sac_operator.permissions[0].id}, 
                            "1"=>{"enabled"=>"1", "id"=>sac_operator.permissions[1].id}, 
                            "2"=>{"enabled"=>"0", "id"=>sac_operator.permissions[2].id}
                            }
                          }

  it "should receive a params with permissions and return permissions" do
  	permission_map_builder = Factory.build(:permission_map_builder, 
  											:permissions => sac_operator.permissions)
  	permission_map_builder.should_receive(:map).with(permissions_hash)
  end

  it "should check if it has permissions associated" do
    sac_operator.has_permission?(sac_operator.permissions[0].id).should eq(true)
  end

end
