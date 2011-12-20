# -*- encoding : utf-8 -*-
require "spec_helper"

describe OrderObserver do
  subject { FactoryGirl.create(:order) }

  it "should enqueue a OrderStatusWorker when the state is updated" do
    Resque.should_receive(:enqueue).with(OrderStatusWorker, subject.id)
    subject.waiting_payment
  end
end
