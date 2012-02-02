# -*- encoding : utf-8 -*-
require 'spec_helper'

describe PermissionMapBuilder do

  let(:collection_index) { Factory(:collection_index) }
  let(:collection_show) { Factory(:collection_show) }
  let(:collection_update) { Factory(:collection_update) }

  it "should receive attributes and map a hash with permission id as key and state as value" do
    pending
  end

  it "should add permissions to an array of permissions if it doesnt exist" do
    pending
  end

  it "should remove a permission from an array of permissions if it exists" do
    pending
  end

  
end
