# -*- encoding : utf-8 -*-
require 'spec_helper'

describe Admin do
  context "checking roles" do
    it "should check for a existing role" do
      admin = FactoryGirl.create(:admin_superadministrator)
      admin.has_role?(:superadministrator).should eq(true)
    end
  end
end
