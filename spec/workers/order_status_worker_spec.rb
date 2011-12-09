# -*- encoding : utf-8 -*-
require "spec_helper"

describe OrderStatusWorker do
  let(:order) { FactoryGirl.create(:clean_order) }
  let(:mock_mail) { double :mail }

  it "should send the invite e-mail given an order id" do
    mock_mail.should_receive(:deliver)
    OrderStatusMailer.should_receive(:order_requested).with(order).and_return(mock_mail)
    described_class.perform(order.id)
  end
end
