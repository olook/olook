# -*- encoding : utf-8 -*-
require "spec_helper"

describe Abacos::ConfirmPayment do
  before :each do
    described_class.stub(:create_confirm_order_event)
    described_class.stub(:create_enqueue_confirm_order_event)
    described_class.stub(:create_enqueue_insert_order_event)
  end
  describe "#perform" do
    it "should raise an error and enqueue a Abacos::ConfirmPayment if the order doesn't exist on Abacos" do
      Order.stub(:find_by_number).with(123).and_return(order = double(:number => 111))
      Abacos::OrderAPI.should_receive(:'order_exists?').with(123).and_return(false)
      Resque.should_receive(:enqueue).with(Abacos::InsertOrder, order.number)
      Resque.should_receive(:enqueue_in_with_queue).with(:delayed_payment, 15.minutes, Abacos::ConfirmPayment, order.number)
      expect {
        described_class.perform(123)
      }.to raise_error "Order number 123 doesn't exist on Abacos"
    end

    context "if the order exists, it should try to insert the order on Abacos" do
      before :each do
        Abacos::OrderAPI.should_receive(:'order_exists?').with(123).and_return(true)
        Order.stub(:find_by_number).with(123).and_return(:fake_order)
        Abacos::ConfirmarPagamento.should_receive(:new).with(:fake_order).and_return(:fake_confirmar_pagamento)
      end

      it 'should return true if the process is successful' do
        Abacos::OrderAPI.should_receive(:confirm_payment).with(:fake_confirmar_pagamento).and_return(true)
        described_class.perform(123).should be_true
      end
      it 'should raise an error if it fails' do
        Abacos::OrderAPI.should_receive(:confirm_payment).with(:fake_confirmar_pagamento).and_raise
        expect {
          described_class.perform(123)
        }.to raise_error
      end
    end
  end
end
