# -*- encoding : utf-8 -*-
require "spec_helper"

describe OrderObserver do
  context "on create" do
   it "should enqueue a job to update the inventory" do
     Resque.should_receive(:enqueue).with(Abacos::UpdateInventory)
     FactoryGirl.create(:order)
   end
  end

  context "before destroy" do
    it "returns credit to the user" do
      user = FactoryGirl.create(:member)
      order = FactoryGirl.create(:order, :credits => 5.3, :user => user)

      Credit.should_receive(:add).with(5.3, user, order)
      order.destroy
    end
  end
end
