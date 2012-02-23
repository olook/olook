# -*- encoding : utf-8 -*-
require "spec_helper"

describe OrderObserver do
  context "on update" do
    subject { FactoryGirl.create(:order) }
    it "should enqueue a OrderStatusWorker when the state is updated" do
      Resque.should_receive(:enqueue).with(OrderStatusWorker, subject.id)
      subject.waiting_payment
    end

    it "should use the coupon when authorized" do
      Resque.stub(:enqueue_in)
      subject.should_receive(:use_coupon)
      subject.waiting_payment
      subject.authorized
    end
  end

  context "on create" do
   it "should enqueue a job to update the inventory" do
     Resque.should_receive(:enqueue).with(Abacos::UpdateInventory)
     FactoryGirl.create(:order)
   end
  end
end
