# encoding: utf-8
require 'spec_helper'

describe Order do
  before do
    Resque.stub(:enqueue)
    Resque.stub(:enqueue_in)
  end

  let!(:loyalty_program_credit_type) { FactoryGirl.create(:loyalty_program_credit_type) }
  let!(:invite_credit_type) { FactoryGirl.create(:invite_credit_type) }

  subject { FactoryGirl.create(:clean_order)}
  let(:basic_shoe) { FactoryGirl.create(:basic_shoe) }
  let(:basic_shoe_35) { FactoryGirl.create(:basic_shoe_size_35, :product => basic_shoe) }
  let(:basic_shoe_37) { FactoryGirl.create(:basic_shoe_size_37, :product => basic_shoe) }
  let(:basic_shoe_40) { FactoryGirl.create(:basic_shoe_size_40, :product => basic_shoe) }

  let(:quantity) { 3 }
  let(:credits) { 1.89 }

  let(:order_with_payment) { FactoryGirl.create :order_with_payment_authorized }


  it { should belong_to(:user) }
  it { should belong_to(:cart) }

  context "creating a Order" do
    it "should generate a number" do
      order = FactoryGirl.create(:order)
      expected = (order.id * Order::CONSTANT_FACTOR) + Order::CONSTANT_NUMBER
      order.number.should == expected
    end
  end

  context "inventory update" do
    it "should increment the inventory for each item" do
      basic_shoe_35.increment!(:inventory, quantity)
      basic_shoe_40.increment!(:inventory, quantity)
      basic_shoe_35_inventory = basic_shoe_35.inventory
      basic_shoe_40_inventory = basic_shoe_40.inventory
      subject.line_items.create( 
        :variant_id => basic_shoe_35.id,
        :quantity => quantity, 
        :price => basic_shoe_35.price,
        :retail_price => basic_shoe_35.retail_price)
      subject.line_items.create( 
        :variant_id => basic_shoe_40.id,
        :quantity => quantity, 
        :price => basic_shoe_40.price,
        :retail_price => basic_shoe_40.retail_price)
        
      subject.increment_inventory_for_each_item
      basic_shoe_35.reload.inventory.should == basic_shoe_35_inventory + quantity
      basic_shoe_40.reload.inventory.should == basic_shoe_40_inventory + quantity
    end
  end

  describe '#installments' do
    context "when there's no payment" do
      it "should return 1" do
        subject.stub(:erp_payment).and_return(nil)
        subject.installments.should == 1
      end
    end
    context "when there's a payment" do
      it "should return the number of installments of the payment" do
        subject.stub_chain(:erp_payment, :payments).and_return(3)
        subject.installments.should == 3
      end
    end
  end

  context "ERP(abacos) integration" do
    context "when the order is waiting payment" do
      it "should enqueue a job to insert a order" do
        Resque.should_receive(:enqueue_in).with(Abacos::InsertOrder, subject.number)
        subject
      end

      it "updates order purchased_at with the current time" do
        time = DateTime.new(2012,5,10,23,59,59)
        Time.stub(:now).and_return(time)
        subject.purchased_at.should eq(time)
        subject
      end
    end

    context "when the order is authorized" do
      it "should enqueue a job to confirm a payment" do
        Resque.stub(:enqueue)
        Resque.should_receive(:enqueue_in).with(20.minutes, Abacos::ConfirmPayment, order_with_payment.number)
        order_with_payment.authorized
      end
    end
  end

  describe "State machine" do
    it "should set authorized" do
      order_with_payment.authorized
      order_with_payment.authorized?.should be_true
    end

    it "should set authorized" do
      order_with_payment.authorized
      order_with_payment.under_review
      order_with_payment.under_review?.should be_true
    end

    it "should set canceled" do
      subject.canceled
      subject.canceled?.should be_true
    end

    it "should set canceled given not_delivered" do
      order_with_payment.authorized
      order_with_payment.picking
      order_with_payment.delivering
      order_with_payment.not_delivered
      order_with_payment.canceled
      order_with_payment.canceled?.should be_true
    end

    it "should set canceled given in_the_cart" do
      subject.canceled
      subject.canceled?.should be_true
    end

    context 'state to reversed' do
      it "should set reversed from under_review" do
        order_with_payment.authorized
        order_with_payment.reversed
        order_with_payment.reversed?.should be_true
      end

      it "should set reversed from under_review" do
        order_with_payment.authorized
        order_with_payment.under_review
        order_with_payment.reversed
        order_with_payment.reversed?.should be_true
      end

      it "should set reversed from picking" do
        order_with_payment.authorized
        order_with_payment.picking
        order_with_payment.reversed
        order_with_payment.reversed?.should be_true
      end

      it "should set reversed from delivering" do
        order_with_payment.authorized
        order_with_payment.picking
        order_with_payment.delivering
        order_with_payment.reversed
        order_with_payment.reversed?.should be_true
      end

      it "should set reversed from delivered" do
        order_with_payment.authorized
        order_with_payment.picking
        order_with_payment.delivering
        order_with_payment.delivered
        order_with_payment.reversed
        order_with_payment.reversed?.should be_true
      end

      it "should set reversed from not_delivered" do
        order_with_payment.authorized
        order_with_payment.picking
        order_with_payment.delivering
        order_with_payment.not_delivered
        order_with_payment.reversed
        order_with_payment.reversed?.should be_true
      end
    end

    context 'to refunded' do
      it "should set refunded from authorized" do
        order_with_payment.authorized
        order_with_payment.refunded
        order_with_payment.refunded?.should be_true
      end

      it "should set refunded from picking" do
        order_with_payment.authorized
        order_with_payment.picking
        order_with_payment.refunded
        order_with_payment.refunded?.should be_true
      end

      it "should set refunded from delivering" do
        order_with_payment.authorized
        order_with_payment.picking
        order_with_payment.delivering
        order_with_payment.refunded
        order_with_payment.refunded?.should be_true
      end

      it "should set refunded from delivered" do
        order_with_payment.authorized
        order_with_payment.picking
        order_with_payment.delivering
        order_with_payment.delivered
        order_with_payment.refunded
        order_with_payment.refunded?.should be_true
      end

      it "should set refunded from not_delivered" do
        order_with_payment.authorized
        order_with_payment.picking
        order_with_payment.delivering
        order_with_payment.not_delivered
        order_with_payment.refunded
        order_with_payment.refunded?.should be_true
      end
    end

    it "should set refunded" do
      order_with_payment.authorized
      order_with_payment.under_review
      order_with_payment.refunded
      order_with_payment.refunded?.should be_true
    end

    it "should set picking" do
      order_with_payment.authorized
      order_with_payment.picking
      order_with_payment.picking?.should be_true
    end

    it "should set delivering" do
      order_with_payment.authorized
      order_with_payment.picking
      order_with_payment.delivering
      order_with_payment.delivering?.should be_true
    end

    it "should set delivered" do
      order_with_payment.authorized
      order_with_payment.picking
      order_with_payment.delivering
      order_with_payment.delivered
      order_with_payment.delivered?.should be_true
    end

    it "should set not_delivered" do
      order_with_payment.authorized
      order_with_payment.picking
      order_with_payment.delivering
      order_with_payment.not_delivered
      order_with_payment.not_delivered?.should be_true
    end
  end

  describe "Order#status" do
    it "should return the status" do
      subject.status.should eq(Order::STATUS[subject.state])
    end
  end

  describe '#with_payment' do
    let!(:order_with_payment) { FactoryGirl.create :order }
    let!(:order_without_payment) do
      order = FactoryGirl.create :clean_order
      order.payments.destroy_all
      order
    end

    it 'should include the order with the payment' do
      described_class.with_payment.all.should include(order_with_payment)
    end
    it 'should not include the order without the payment' do
      described_class.with_payment.all.should_not include(order_without_payment)
    end
  end

  describe "delivery time" do
    it "should return the delivery time minus the time that the order is on warehouse" do
      freight = FactoryGirl.create(:freight, :order => subject)
      subject.delivery_time_for_a_shipped_order.should == freight.delivery_time - Order::WAREHOUSE_TIME
    end
  end

  describe "Audit trail" do
    it "should audit the transition" do
      order_with_payment.authorized
      transition = order_with_payment.order_state_transitions.last
      transition.event.should == "authorized"
      transition.from.should == "waiting_payment"
      transition.to.should == "authorized"
    end
  end

  describe "order metadata" do
    subject do 
      FactoryGirl.create(:clean_order, 
        :user_first_name => 'Jéssica',
        :user_last_name => 'Gomes'
      )
    end
    
    it { subject.user_name.should == 'Jéssica Gomes'}
    
  end
end