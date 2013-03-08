# -*- encoding : utf-8 -*-
require "spec_helper"

describe Abacos::CancelOrder do
  
  describe "#perform" do
    let(:fake_order) { mock_model(Order) }

    before do
      fake_order.stub(:canceled?).and_return(true)
      Order.stub(:find_by_number).with(123).and_return(fake_order)
    end

    context "Order does not exist on abacos" do

      before do
        described_class.should_receive(:should_cancel?).and_return(true)
        Abacos::OrderAPI.should_receive(:'order_exists?').with(123).and_return(false)
      end

      it "cancel the order, but not ask ABACOS to cancel it" do
        fake_order.should_receive(:canceled).exactly(1).times
        Abacos::OrderAPI.should_not_receive(:cancel_order)
        described_class.perform(123)
      end
    end

    context "if the order exists, it should try to cancel the order on Abacos" do
      before :each do
        Order.stub(:find_by_number).with(123).and_return(fake_order)
        fake_order.stub(:canceled?).and_return(true)
      end

      it 'should return true if the process is successful' do
        Abacos::OrderAPI.should_receive(:'order_exists?').with(123).and_return(true)
        Abacos::CancelarPedido.should_receive(:new).with(fake_order).and_return(:fake_cancelar_pedido)
        described_class.should_receive(:should_cancel?).and_return(true)
        fake_order.should_receive(:canceled).exactly(1).times        
        Abacos::OrderAPI.should_receive(:cancel_order).and_return(true)
        described_class.perform(123).should be_true
      end

      it 'should return false if process is not successful' do
        fake_order.stub(:can_be_canceled?).and_return(false)
        described_class.should_receive(:should_cancel?).and_return(false)
        fake_order.should_not_receive(:canceled)
        fake_order.stub(:canceled?).and_return(false)
        described_class.perform(123).should be_false
      end
    end
  end
end
