# -*- encoding : utf-8 -*-
require "spec_helper"

describe OrderObserver do
  context "on create" do
   it "should enqueue a job to update the inventory" do
     Resque.should_receive(:enqueue).with(Abacos::UpdateInventory)
     FactoryGirl.create(:order)
   end
  end
end
