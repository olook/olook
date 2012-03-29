# -*- encoding : utf-8 -*-
require "spec_helper"

describe OrderStatusWorker do
  before :each do
    described_class.stub(:create_order_event)
  end

  # describe '#perform' do
  #   let(:order) { FactoryGirl.create(:clean_order) }

  #   before :each do
  #     order.waiting_payment
  #   end

  #   it "should send email" do
  #     Order.any_instance.stub(:user).and_return(stub(:email => "leinboston@hotmail.com"))
  #     described_class.should_receive(:send_email).with(order)
  #     described_class.perform(order.id)
  #   end
  #  end

  # describe '#send_email' do
  #   let(:order) { FactoryGirl.create(:clean_order) }
  #   let(:order_cc) { FactoryGirl.create(:clean_order_credit_card) }
  #   let(:mock_mail) { double :mail }

  #   before do
  #     Resque.stub(:enqueue)
  #     Resque.stub(:enqueue_in)
  #   end

  #   describe "send order_requested" do
  #     it 'should send if the order is wainting_payment and has an associated payment' do
  #       order.waiting_payment
  #       order.stub(:payment).and_return(:some_payment)
  #       mock_mail.should_receive(:deliver)
  #       OrderStatusMailer.should_receive(:order_requested).with(order).and_return(mock_mail)
  #       described_class.send_email(order)
  #     end
  #     it 'should do nothing if the order is wainting_payment and but has no associated payment' do
  #       order.update_attributes(:payment => nil)
  #       OrderStatusMailer.should_not_receive(:order_requested).with(order)
  #       described_class.send_email(order)
  #     end
  #   end

  #   it "should send payment_confirmed" do
  #     order.waiting_payment
  #     order.authorized
  #     mock_mail.should_receive(:deliver)
  #     OrderStatusMailer.should_receive(:payment_confirmed).with(order).and_return(mock_mail)
  #     described_class.send_email(order)
  #   end

  #   it "should send order_shipped" do
  #     order.waiting_payment
  #     order.authorized
  #     order.picking
  #     order.delivering
  #     mock_mail.should_receive(:deliver)
  #     OrderStatusMailer.should_receive(:order_shipped).with(order).and_return(mock_mail)
  #     described_class.send_email(order)
  #   end

  #   it "should send order_delivered" do
  #     order.waiting_payment
  #     order.authorized
  #     order.picking
  #     order.delivering
  #     order.delivered
  #     mock_mail.should_receive(:deliver)
  #     OrderStatusMailer.should_receive(:order_delivered).with(order).and_return(mock_mail)
  #     described_class.send_email(order)
  #   end

  #   it "should send payment_refused when canceled" do
  #     order_cc.waiting_payment
  #     order_cc.canceled
  #     mock_mail.should_receive(:deliver)
  #     OrderStatusMailer.should_receive(:payment_refused).with(order_cc).and_return(mock_mail)
  #     described_class.send_email(order_cc)
  #   end

  #   it "should send payment_refused when reverted" do
  #     order_cc.waiting_payment
  #     order_cc.authorized
  #     order_cc.under_review
  #     order_cc.reversed
  #     mock_mail.should_receive(:deliver)
  #     OrderStatusMailer.should_receive(:payment_refused).with(order_cc).and_return(mock_mail)
  #     described_class.send_email(order_cc)
  #   end
  # end
end
