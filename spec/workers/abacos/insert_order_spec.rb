# -*- encoding : utf-8 -*-
require "spec_helper"

describe Abacos::InsertOrder do
  before :each do
    described_class.stub(:create_order_event)
  end

  describe "#perform" do
    it 'should parse and check the validity of the order' do
      described_class.should_receive(:parse_and_check_order).with(123)
      described_class.stub(:export_client).and_return(false)
      described_class.perform(123)
    end

    context 'if the order is valid and parsed' do
      before :each do
        described_class.stub(:parse_and_check_order).with(123).and_return(@order = double)
      end
      context 'and it can export the client' do
        before :each do
          described_class.should_receive(:export_client).with(@order).and_return(true)
        end
        it 'should try to insert the order' do
          described_class.should_receive(:insert_order).with(@order)
          described_class.perform(123)
        end
        it 'should enqueue a Job to cancel the order if the order is canceled' do
          described_class.stub(:insert_order).and_return(true)
          @order.stub(:canceled?).and_return(true)
          Resque.should_receive(:enqueue).with(Abacos::CancelOrder, 123)
          described_class.perform(123)
        end
      end
      context "and it can't export the client" do
        before :each do
          described_class.should_receive(:export_client).with(@order).and_return(false)
        end
        it 'should not try to insert the order' do
          described_class.should_not_receive(:insert_order).with(@order)
          described_class.perform(123)
        end
      end
    end
  end

  describe '#parse_and_check_order' do
    let(:mock_order) { mock_model Order, :payment => nil }
    before :each do
      Order.stub(:find_by_number).with(123).and_return(mock_order)
    end

    it "should raise an error if the order doesn't have an associated payment" do
      expect {
        described_class.send(:parse_and_check_order, 123)
      }.to raise_error "Order number 123 doesn't have an associated payment"
    end
    it "should raise an error if the order already exists on Abacos" do
      mock_order.stub(:payment).and_return(:some_payment)
      Abacos::OrderAPI.should_receive(:'order_exists?').with(123).and_return(true)
      expect {
        described_class.send(:parse_and_check_order, 123)
      }.to raise_error "Order number 123 already exist on Abacos"
    end
  end

  describe '#export_client' do
    let(:order) do
      result = mock_model Order
      result.stub(:user).and_return(:user)
      result.stub_chain(:freight, :address).and_return(:address)
      result
    end
    it 'should create a new cliente' do
      Abacos::Cliente.should_receive(:new).with(:user, :address)
      Abacos::ClientAPI.stub(:export_client)
      described_class.send(:export_client, order)
    end
    it 'should call the export client API' do
      Abacos::Cliente.stub(:new).with(:user, :address).and_return(:cliente)
      Abacos::ClientAPI.should_receive(:export_client).with(:cliente)
      described_class.send(:export_client, order)
    end
  end

  describe '#insert_order' do
    it 'should create a new pedido' do
      Abacos::Pedido.should_receive(:new).with(:order)
      Abacos::OrderAPI.stub(:insert_order)
      described_class.send(:insert_order, :order)
    end
    it 'should call the insert order API' do
      Abacos::Pedido.stub(:new).with(:order).and_return(:order)
      Abacos::OrderAPI.should_receive(:insert_order).with(:order)
      described_class.send(:insert_order, :order)
    end
  end
end
