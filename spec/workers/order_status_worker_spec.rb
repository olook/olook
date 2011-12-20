# -*- encoding : utf-8 -*-
require "spec_helper"

describe OrderStatusWorker do
  describe '#perform' do
    let(:order) { FactoryGirl.create(:clean_order) }

    before :each do
      order.waiting_payment
    end

    it 'should send e-mails' do
      described_class.should_receive(:send_email).with(order)
      described_class.stub(:integrate_with_abacos)
      described_class.perform(order.id)
    end
    it 'should integrate with Abacos' do
      described_class.stub(:send_email)
      described_class.should_receive(:integrate_with_abacos).with(order)
      described_class.perform(order.id)
    end
  end

  describe '#send_email' do
    let(:order) { FactoryGirl.create(:clean_order) }
    let(:mock_mail) { double :mail }

    describe "send order_requested" do
      it 'should send if the order is wainting_payment and has an associated payment' do
        order.waiting_payment
        order.stub(:payment).and_return(:some_payment)
        mock_mail.should_receive(:deliver)
        OrderStatusMailer.should_receive(:order_requested).with(order).and_return(mock_mail)
        described_class.send_email(order)
      end
      it 'should do nothing if the order is wainting_payment and but has no associated payment' do
        order.update_attributes(:payment => nil)
        OrderStatusMailer.should_not_receive(:order_requested).with(order)
        described_class.send_email(order)
      end
    end

    it "should send payment_confirmed" do
      order.waiting_payment
      order.authorized
      mock_mail.should_receive(:deliver)
      OrderStatusMailer.should_receive(:payment_confirmed).with(order).and_return(mock_mail)
      described_class.send_email(order)
    end

    it "should send payment_refused when canceled" do
      order.waiting_payment
      order.canceled
      mock_mail.should_receive(:deliver)
      OrderStatusMailer.should_receive(:payment_refused).with(order).and_return(mock_mail)
      described_class.send_email(order)
    end

    it "should send payment_refused when reverted" do
      order.waiting_payment
      order.authorized
      order.under_review
      order.reversed
      mock_mail.should_receive(:deliver)
      OrderStatusMailer.should_receive(:payment_refused).with(order).and_return(mock_mail)
      described_class.send_email(order)
    end

    it "should send delivering order e-mail when delivering" do
      order.waiting_payment
      order.authorized
      order.picking
      order.delivering
      mock_mail.should_receive(:deliver)
      OrderStatusMailer.should_receive(:delivering_order).with(order).and_return(mock_mail)
      described_class.send_email(order)
    end
  end

  describe '#integrate_with_abacos' do
    let(:order) do
      mock_model Order, :number => 456,
                        :'waiting_payment?' => false,
                        :'authorized?' => false
    end

    describe 'when the order state is waiting_payment' do
      before :each do
        order.stub(:'waiting_payment?').and_return(true)
      end
      it "should send the order to Abacos if it also has an associated payment" do
        order.stub(:payment).and_return(:some_payment)
        Resque.should_receive(:enqueue).with(Abacos::InsertOrder, order.number)
        described_class.integrate_with_abacos(order)
      end
      it "should do nothing if it doesn't have an associated payment" do
        order.stub(:payment).and_return(nil)
        Resque.should_not_receive(:enqueue).with(Abacos::InsertOrder, order.number)
        described_class.integrate_with_abacos(order)
      end
    end

    describe 'when the order state is authorized' do
      before :each do
        order.stub(:'authorized?').and_return(true)
      end
      it "should tell Abacos it was paid, need to wait a couple minutes to avoid errors" do
        Resque.should_receive(:enqueue_in).with(10.minutes, Abacos::ConfirmPayment, order.number)
        described_class.integrate_with_abacos(order)
      end
    end
  end
end
