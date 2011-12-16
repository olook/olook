# -*- encoding : utf-8 -*-
require "spec_helper"

describe Abacos::OrderStatus do
  let(:downloaded_status) { load_abacos_fixture :order_status }
  let(:parsed_data) { described_class.parse_abacos_data downloaded_status }
  subject { described_class.new parsed_data }

  describe '#integrate' do
    it 'should find_and_check_order' do
      subject.should_receive(:find_and_check_order)
      subject.stub(:change_order_state)
      subject.stub(:confirm_order_status)
      subject.integrate
    end
    it 'should change_order_state' do
      subject.stub(:find_and_check_order)
      subject.should_receive(:change_order_state)
      subject.stub(:confirm_order_status)
      subject.integrate
    end
    it 'should confirm_order_status' do
      subject.stub(:find_and_check_order)
      subject.stub(:change_order_state)
      subject.should_receive(:confirm_order_status)
      subject.integrate
    end
  end

  describe "#find_and_check_order" do
    context "when the order doesn't exist" do
      before :each do
        subject.stub(:order_number).and_return(0)
      end
      it "should raise an error" do
        expect {
          subject.send :find_and_check_order, 0
        }.to raise_error "Order number 0 doesn't exist"
      end
    end

    context 'when the order is in an invalid state' do
      let(:invalid_order) { FactoryGirl.create :clean_order }      
      it "should raise an error" do
        subject.stub(:order_number).and_return(invalid_order.number)
        expect {
          subject.send :find_and_check_order, invalid_order.number
        }.to raise_error "Order number #{invalid_order.number} state is #{invalid_order.state}, which is invalid for integration"
      end
    end
  end

  describe '#change_order_state' do
    let(:order) { FactoryGirl.create :clean_order }
    let(:default_order_state) do
      {
        :integration_protocol => 'fake_protocol',
        :order_number         => order.number,
        :new_state            => :none,
        :datetime             => DateTime.now,
        :invoice              => 'SÉRIE 1 - NÚMERO 21',
        :invoice_datetime     => DateTime.now,
        :tracking_code        => 'TRACKING-CORREIO',
        :cancelation_reason   => ''
      }
    end

    context 'when the original order state is authorized' do
      before :each do
        order.authorized
        order.authorized?.should be_true
      end
      
      context "and the new state is picking" do
        subject { described_class.new default_order_state.merge(:new_state => :picking) }
        it "should change the state to picking" do
          subject.send :change_order_state, order
          order.reload
          order.picking?.should be_true
        end
      end

      context "and the new state is delivering" do
        subject { described_class.new default_order_state.merge(:new_state => :delivering) }
        it "should change the state to delivering" do
          subject.send :change_order_state, order
          order.reload
          order.delivering?.should be_true
        end
      end

      context "and the new state is delivered" do
        subject { described_class.new default_order_state.merge(:new_state => :delivered) }
        it "should change the state to delivered" do
          subject.send :change_order_state, order
          order.reload
          order.delivered?.should be_true
        end
      end
    end
    
    context 'when the original order state is picking' do
      before :each do
        order.authorized
        order.picking
        order.picking?.should be_true
      end
      
      context "and the new state is delivering" do
        subject { described_class.new default_order_state.merge(:new_state => :delivering) }
        it "should change the state to delivering" do
          subject.send :change_order_state, order
          order.reload
          order.delivering?.should be_true
        end
      end

      context "and the new state is delivered" do
        subject { described_class.new default_order_state.merge(:new_state => :delivered) }
        it "should change the state to delivered" do
          subject.send :change_order_state, order
          order.reload
          order.delivered?.should be_true
        end
      end
    end

    context 'when the original order state is delivering' do
      before :each do
        order.authorized
        order.picking
        order.delivering
        order.delivering?.should be_true
      end
      
      context "and the new state is delivered" do
        subject { described_class.new default_order_state.merge(:new_state => :delivered) }
        it "should change the state to delivered" do
          subject.send :change_order_state, order
          order.reload
          order.delivered?.should be_true
        end
      end
    end
  end

  describe "#confirm_order_status" do
    let(:fake_protocol) { 'STAT123' }
    it 'should add a task on the queue to integrate' do
      subject.stub(:integration_protocol).and_return(fake_protocol)
      Resque.should_receive(:enqueue).with(Abacos::ConfirmOrderStatus, fake_protocol)
      subject.send :confirm_order_status
    end
  end

  describe "class methods" do
    describe '#parse_abacos_data' do
      it '#integration_protocol' do
        subject.integration_protocol.should == "FD81F3EA-D028-40C0-BC1E-399981A65443"
      end

      it '#order_number' do
        subject.order_number.should == "8735"
      end

      it '#new_state' do
        subject.new_state.should == :canceled
      end

      it '#datetime' do
        subject.datetime.should == DateTime.civil(2011, 12, 14, 17, 12, 30)
      end
      
      it '#invoice' do
        subject.invoice.should == "SÉRIE 1 - NÚMERO 18"
      end
      
      it '#invoice_datetime' do
        subject.invoice_datetime.should == DateTime.civil(2011, 12, 14, 9, 12, 42)
      end
      
      it '#tracking_code' do
        subject.tracking_code.should == "XYZ-CORREIO"
      end

      it '#cancelation_reason' do
        subject.cancelation_reason.should == '55 - SOME REASON'
      end
    end
    
    describe '#parse_status' do
      it "should return :picking when status '01 - EM SEPARACAO'" do
        described_class.parse_status('01').should == :picking
      end
      it "should return :picking when status '02 - FATURADO'" do
        described_class.parse_status('02').should == :picking
      end
      it "should return :canceled when status '03 - CANCELADO'" do
        described_class.parse_status('03').should == :canceled
      end
      it "should return :canceled when status '04 - DESPACHADO'" do
        described_class.parse_status('04').should == :delivering
      end
      it "should return :canceled when status '05 - ENTREGUE'" do
        described_class.parse_status('05').should == :delivered
      end
    end

    describe 'parse_datetime' do
      it 'should return a datetime parsing the format of 11042008 17:30:55.458' do
        described_class.parse_datetime('11042008 17:30:55.458').should == DateTime.civil(2008, 04, 11, 17, 30, 55)
      end
      it 'should return nil if the date is empty' do
        described_class.parse_datetime(nil).should be_nil
      end
      it 'should return nil if the date is an empty string' do
        described_class.parse_datetime('').should be_nil
      end
    end

    describe 'parse_invoice' do
      it 'should return a string with the invoice series and number' do
        described_class.parse_invoice(1, 321).should == "SÉRIE 1 - NÚMERO 321"
      end
    end

    describe 'parse_cancelation' do
      it 'should return a string with the cancelation code and reason' do
        described_class.parse_cancelation(55, 'SOME REASON').should == "55 - SOME REASON"
      end
    end
  end
end
