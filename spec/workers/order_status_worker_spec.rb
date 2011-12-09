# -*- encoding : utf-8 -*-
require "spec_helper"

describe OrderStatusWorker do
  let(:order) { FactoryGirl.create(:clean_order) }
  let(:mock_mail) { double :mail }

  it "should send order_requested" do
    mock_mail.should_receive(:deliver)
    OrderStatusMailer.should_receive(:order_requested).with(order).and_return(mock_mail)
    described_class.perform(order.id)
  end

  it "should send payment_confirmed" do
    order.completed
    mock_mail.should_receive(:deliver)
    OrderStatusMailer.should_receive(:payment_confirmed).with(order).and_return(mock_mail)
    described_class.perform(order.id)
  end

  it "should send payment_refused when canceled" do
    order.canceled
    mock_mail.should_receive(:deliver)
    OrderStatusMailer.should_receive(:payment_refused).with(order).and_return(mock_mail)
    described_class.perform(order.id)
  end

  it "should send payment_refused when reverted" do
    order.under_review
    order.reversed
    mock_mail.should_receive(:deliver)
    OrderStatusMailer.should_receive(:payment_refused).with(order).and_return(mock_mail)
    described_class.perform(order.id)
  end
end
