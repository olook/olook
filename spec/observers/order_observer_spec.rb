# -*- encoding : utf-8 -*-
require "spec_helper"

describe OrderObserver do
  subject { FactoryGirl.create(:order) }

  it "should enqueue a OrderStatusWorker when the state is updated" do
    Resque.should_receive(:enqueue).with(OrderStatusWorker, subject.id)
    subject.waiting_payment
  end

  it "should update the inventory when necessary" do
    OrderInventory.stub(:new).and_return(order_inventory = mock)
    order_inventory.stub(:available_for_rollback?).and_return(true)
    order_inventory.should_receive(:rollback).at_least(1).times
    subject.canceled
  end
end
