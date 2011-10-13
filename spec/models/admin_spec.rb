require 'spec_helper'

describe Admin do
  context "checking roles" do
    it "should be a admin" do
      admin = FactoryGirl.create(:admin)
      admin.admin?.should eq(true)
    end

    it "should be a stylist" do
      stylist = FactoryGirl.create(:stylist)
      stylist.stylist?.should eq(true)
    end
  end
end
