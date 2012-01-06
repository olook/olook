# -*- encoding : utf-8 -*-
require "spec_helper"

describe OrderInventory do
  let(:order) { mock_model(Order) }
  subject { OrderInventory.new order }

  it "should rollback the inventory" do
    order.should_receive(:rollback_inventory)
    subject.stub(:available_for_rollback?).and_return(true)
    subject.rollback
  end

  it "should return true for available_for_rollback? when the order is canceled" do
    order.stub(:canceled?).and_return(true)
    subject.available_for_rollback?.should be_true
  end

  it "should return true for available_for_rollback? when the order is refunded" do
    order.stub(:canceled?).and_return(false)
    order.stub(:reversed?).and_return(false)
    order.stub(:refunded?).and_return(true)
    subject.available_for_rollback?.should be_true
  end

  it "should return true for available_for_rollback? when the order is reversed" do
    order.stub(:canceled?).and_return(false)
    order.stub(:refunded?).and_return(true)
    order.stub(:reversed?).and_return(true)
    subject.available_for_rollback?.should be_true
  end
end
