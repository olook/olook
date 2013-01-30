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

  let!(:order_with_waiting_payment) { FactoryGirl.create :order_with_waiting_payment }

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
      let(:another_order_with_waiting_payment) { FactoryGirl.create :order_with_waiting_payment }

      it "should enqueue a job to confirm a payment" do
        Resque.stub(:enqueue)
        Resque.should_receive(:enqueue_in).with(20.minutes, Abacos::ConfirmPayment, another_order_with_waiting_payment.number)
        another_order_with_waiting_payment.authorized
      end
    end
  end

  describe "#expected_delivery_on" do
    it "returns the freight delivery_time converted to a date" do
      expect(order_with_waiting_payment.expected_delivery_on.to_s).
        to eql(order_with_waiting_payment.freight.delivery_time.days.from_now.to_s)
    end
  end

  describe "#shipping_service_name" do
    it "returns the freight.shipping_service" do
      expect(order_with_waiting_payment.shipping_service_name).
        to eql(order_with_waiting_payment.freight.shipping_service.name)
    end
  end

  describe "State machine transitions" do
    context 'authorized' do
      it "returns true" do
        order_with_waiting_payment.authorized
        expect(order_with_waiting_payment.authorized?).to be_true
      end

      it "sets #expected_delivery_on" do
        order_with_waiting_payment.authorized
        expect(order_with_waiting_payment.expected_delivery_on).to_not be_nil

        delivery_date = order_with_waiting_payment.freight.delivery_time.days.from_now
        expect(order_with_waiting_payment.expected_delivery_on.to_s).to eq(delivery_date.to_s)
      end

      it "sets #shipping_service_name" do
        order_with_waiting_payment.authorized
        expect(order_with_waiting_payment.shipping_service_name).to_not be_nil

        shipping_service_name = order_with_waiting_payment.freight.shipping_service.name
        expect(order_with_waiting_payment.shipping_service_name).to eq(shipping_service_name)
      end
    end

    context 'under_review' do
      context 'from authorized' do
        it "returns true" do
          order_with_waiting_payment.authorized
          order_with_waiting_payment.under_review
          order_with_waiting_payment.under_review?.should be_true
        end
      end
    end

    context "canceled" do
      it "returns true" do
        subject.canceled
        subject.canceled?.should be_true
      end

      context "from not_delivered" do
        it "returns true" do
          order_with_waiting_payment.authorized
          order_with_waiting_payment.picking
          order_with_waiting_payment.delivering
          order_with_waiting_payment.not_delivered
          order_with_waiting_payment.canceled
          order_with_waiting_payment.canceled?.should be_true
        end
      end
    end

    context 'reversed' do
      context 'from authorized' do
        it "returns true" do
          order_with_waiting_payment.authorized
          order_with_waiting_payment.reversed
          order_with_waiting_payment.reversed?.should be_true
        end
      end

      context "from under_review" do
        it "returns true" do
          order_with_waiting_payment.authorized
          order_with_waiting_payment.under_review
          order_with_waiting_payment.reversed
          order_with_waiting_payment.reversed?.should be_true
        end
      end

      context "from picking" do
        it "returns true" do
          order_with_waiting_payment.authorized
          order_with_waiting_payment.picking
          order_with_waiting_payment.reversed
          order_with_waiting_payment.reversed?.should be_true
        end
      end

      context "from delivering" do
        it "returns true" do
          order_with_waiting_payment.authorized
          order_with_waiting_payment.picking
          order_with_waiting_payment.delivering
          order_with_waiting_payment.reversed
          order_with_waiting_payment.reversed?.should be_true
        end
      end

      context "from delivered" do
        it "returns true" do
          order_with_waiting_payment.authorized
          order_with_waiting_payment.picking
          order_with_waiting_payment.delivering
          order_with_waiting_payment.delivered
          order_with_waiting_payment.reversed
          order_with_waiting_payment.reversed?.should be_true
        end
      end

      context "from not_delivered" do
        it "returns true" do
          order_with_waiting_payment.authorized
          order_with_waiting_payment.picking
          order_with_waiting_payment.delivering
          order_with_waiting_payment.not_delivered
          order_with_waiting_payment.reversed
          order_with_waiting_payment.reversed?.should be_true
        end
      end
    end

    context 'refunded' do
      it "returns true" do
        order_with_waiting_payment.authorized
        order_with_waiting_payment.under_review
        order_with_waiting_payment.refunded
        order_with_waiting_payment.refunded?.should be_true
      end

      context "from authorized" do
        it "returns true" do
          order_with_waiting_payment.authorized
          order_with_waiting_payment.refunded
          order_with_waiting_payment.refunded?.should be_true
        end
      end

      context "from picking" do
        it "returns true" do
          order_with_waiting_payment.authorized
          order_with_waiting_payment.picking
          order_with_waiting_payment.refunded
          order_with_waiting_payment.refunded?.should be_true
        end
      end

      context "from delivering" do
        it "returns true" do
          order_with_waiting_payment.authorized
          order_with_waiting_payment.picking
          order_with_waiting_payment.delivering
          order_with_waiting_payment.refunded
          order_with_waiting_payment.refunded?.should be_true
        end
      end

      context "from delivered" do
        it "returns true" do
          order_with_waiting_payment.authorized
          order_with_waiting_payment.picking
          order_with_waiting_payment.delivering
          order_with_waiting_payment.delivered
          order_with_waiting_payment.refunded
          order_with_waiting_payment.refunded?.should be_true
        end
      end

      context "from not_delivered" do
        it "returns true" do
          order_with_waiting_payment.authorized
          order_with_waiting_payment.picking
          order_with_waiting_payment.delivering
          order_with_waiting_payment.not_delivered
          order_with_waiting_payment.refunded
          order_with_waiting_payment.refunded?.should be_true
        end
      end
    end

    context "picking" do
      context "from authorized" do
        it "should set picking" do
          order_with_waiting_payment.authorized
          order_with_waiting_payment.picking
          order_with_waiting_payment.picking?.should be_true
        end
      end
    end

    context "delivering" do
      context "from picking" do
        it "returns true" do
          order_with_waiting_payment.authorized
          order_with_waiting_payment.picking
          order_with_waiting_payment.delivering
          order_with_waiting_payment.delivering?.should be_true
        end
      end
    end

    context "delivered" do
      context "from delivering" do
        it "returns true" do
          order_with_waiting_payment.authorized
          order_with_waiting_payment.picking
          order_with_waiting_payment.delivering
          order_with_waiting_payment.delivered
          order_with_waiting_payment.delivered?.should be_true
        end
      end
    end

    context "not delivered" do
      context "from delivering" do
        it "should set not_delivered" do
          order_with_waiting_payment.authorized
          order_with_waiting_payment.picking
          order_with_waiting_payment.delivering
          order_with_waiting_payment.not_delivered
          order_with_waiting_payment.not_delivered?.should be_true
        end
      end
    end
  end

  describe "Order#status" do
    it "should return the status" do
      subject.status.should eq(Order::STATUS[subject.state])
    end
  end

  describe '#with_payment' do
    let!(:order_with_waiting_payment) { FactoryGirl.create(:order_with_waiting_payment) }
    let!(:order_without_payment) do
      order = FactoryGirl.create :clean_order
      order.payments.destroy_all
      order
    end

    it 'should include the order with the payment' do
      described_class.with_payment.all.should include(order_with_waiting_payment)
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
      order_with_waiting_payment.authorized
      transition = order_with_waiting_payment.order_state_transitions.last
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

  context "scopes" do
    let(:now) { Time.now }

    context ".with_state" do
      it "returns orders with one state" do
        #I know, weird.. but state comes as :authorized :P
        order = FactoryGirl.create(:order_with_waiting_payment)
        order.update_attribute(:state, 'waiting_payment')
        waiting = Order.with_state("waiting_payment").map(&:state)
        expect(waiting).to have(1).item
        expect(waiting).to include("waiting_payment")
      end
    end

    context ".with_date" do

      it "returns orders on a specific date" do
        orders_today = Order.with_date(now)
        expect(orders_today).to have(1).item
        expect(orders_today.first).to eq(order_with_waiting_payment)
      end

      context "6 or more days" do
        before(:each) do
          2.times do
            past_order = FactoryGirl.create(:order_with_waiting_payment)
            past_order.update_attribute(:updated_at, now - 6.days)
          end
        end

        it "returns all orders from 6 business days ago or before" do
          expect(Order.with_date(now - 6.days).count).to eql 2
        end
      end
    end

    context ".with_expected_delivery_on" do
      let(:expected_delivery_on) { 2.days.from_now }
      let!(:order) { FactoryGirl.create(:order, expected_delivery_on: expected_delivery_on) }

      it "returns orders on expected delivery date" do
        orders = Order.with_expected_delivery_on(expected_delivery_on)
        expect(orders).to have(1).item
        expect(orders.first).to eq(order)
      end

      context "6 or more days" do
        let(:six_days_ago) { 6.business_days.ago }

        before(:each) do
          @past_order = FactoryGirl.create(:order_with_waiting_payment)
          @past_order.update_attribute(:expected_delivery_on, six_days_ago)
        end

        it "returns all orders expected to be delivered 6 business days ago or before" do
          orders = Order.with_expected_delivery_on(six_days_ago)
          expect(orders).to have(1).item
          expect(orders.first).to eq(@past_order)
        end
      end
    end
  end
end
