# -*- encoding : utf-8 -*-
require "spec_helper"

describe Abacos::CancelOrder do
  describe "#perform" do
    it "should raise an error if the order doesn't exist on Abacos" do
      Abacos::OrderAPI.should_receive(:'order_exists?').with(123).and_return(false)
      expect {
        described_class.perform(123)
      }.to raise_error "Order number 123 doesn't exist on Abacos"
    end

    context "if the order exists, it should try to cancel the order on Abacos" do
      before :each do
        @fake_order = mock_model(Order)
        Abacos::OrderAPI.should_receive(:'order_exists?').with(123).and_return(true)
        Order.stub(:find_by_number).with(123).and_return(@fake_order)
      end

      it 'should return true if the process is successful' do
        Abacos::CancelarPedido.should_receive(:new).with(@fake_order).and_return(:fake_cancelar_pedido)
        @fake_order.should_receive(:can_be_canceled?).and_return(true)
        Abacos::OrderAPI.should_receive(:cancel_order).and_return(true)
        described_class.perform(123).should be_true
      end

      it 'should return false if process is not successful' do
        @fake_order.stub(:can_be_canceled?).and_return(false)
        described_class.perform(123).should be_false
      end
    end
  end
end
