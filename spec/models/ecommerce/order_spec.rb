# encoding: utf-8
require 'spec_helper'

describe Order do

  let!(:loyalty_program_credit_type) { FactoryGirl.create(:loyalty_program_credit_type) }
  let!(:invite_credit_type) { FactoryGirl.create(:invite_credit_type) }

  subject { FactoryGirl.create(:clean_order)}
  let(:basic_shoe) { FactoryGirl.create(:shoe, :casual) }
  let(:basic_shoe_35) { FactoryGirl.create(:basic_shoe_size_35, :product => basic_shoe) }
  let(:basic_shoe_37) { FactoryGirl.create(:basic_shoe_size_37, :product => basic_shoe) }
  let(:basic_shoe_40) { FactoryGirl.create(:basic_shoe_size_40, :product => basic_shoe) }

  let(:quantity) { 3 }
  let(:credits) { 1.89 }

  let!(:order) { FactoryGirl.create :order, :with_authorized_credit_card }

  it { should belong_to(:user) }
  it { should belong_to(:cart) }

  context "creating a Order" do
    it "should generate a number" do
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

  describe '#can_be_canceled?' do
    context 'order without payments' do
      let(:order_without_payment) { FactoryGirl.create(:order_without_payment)}

      it 'return true' do
        order_without_payment.can_be_canceled?.should be_true
      end

    end

    context 'order with a canceled payment' do
      let(:order_with_canceled_payment) { FactoryGirl.create(:order_with_canceled_payment)}

      it 'return true' do
        order_with_canceled_payment.can_be_canceled?.should be_true
      end
    end

    context 'order has a canceled and an authorized payment' do
      let(:authorized_payment) {FactoryGirl.create(:credit_card_with_response_authorized, :order => order_with_payments)}
      let(:order_with_payments) { FactoryGirl.create(:order_with_canceled_payment)}

      before do
        order_with_payments.payments << authorized_payment
      end

      context "payment's total_paid is equal to order's amount_paid " do
        before do
          order_with_payments.amount_paid = authorized_payment.total_paid
        end

        it 'return false' do
          order_with_payments.can_be_canceled?.should be_false
        end
      end

      context "payment's total_paid is less than order's amount_paid " do

        it 'return true' do
          order_with_payments.can_be_canceled?.should be_true
        end
      end
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
      it "enqueues a job to insert a order" do
        Resque.should_receive(:enqueue_in).exactly(3).times.with(Abacos::InsertOrder, subject.number)
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
      let(:another_order) { FactoryGirl.create :authorized_order }

      it "should enqueue a job to confirm a payment" do
        Resque.should_receive(:enqueue_in).exactly(3).times.with(20.minutes, Abacos::ConfirmPayment, another_order.number)
        another_order.authorized
      end
    end
  end

  describe "#expected_delivery_on" do
    it "depends on associated freight being defined" do
      expect(order.freight).to_not be_nil
    end

    it "returns the freight delivery_time converted to a date" do
      Timecop.freeze do
        order = FactoryGirl.create :order, :with_authorized_credit_card
        expect(order.expected_delivery_on.to_s).
          to eql(order.freight.delivery_time.business_days.from_now.to_s)
      end
    end
  end

  describe "#shipping_service_name" do
    it "returns the freight.shipping_service" do
      expect(order.shipping_service_name).
        to eql(order.freight.shipping_service.name)
    end
  end

  describe "State machine transitions" do
    context 'authorized' do
      it "returns true" do
        order.authorized
        expect(order.authorized?).to be_true
      end

      it "sets #expected_delivery_on" do
        order.authorized
        expect(order.expected_delivery_on).to_not be_nil

        delivery_date = order.freight.delivery_time.business_days.from_now
        expect(order.expected_delivery_on.to_s).to match(delivery_date.to_s[0 .. -11])
      end

      it "sets #shipping_service_name" do
        order.authorized
        expect(order.shipping_service_name).to_not be_nil

        shipping_service_name = order.freight.shipping_service.name
        expect(order.shipping_service_name).to eq(shipping_service_name)
      end
    end

    context 'under_review' do
      context 'from authorized' do
        it "returns true" do
          order.authorized
          order.under_review
          order.under_review?.should be_true
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
          order.authorized
          order.picking
          order.delivering
          order.not_delivered
          order.canceled
          order.canceled?.should be_true
        end
      end
    end

    context 'reversed' do
      context 'from authorized' do
        it "returns true" do
          order.authorized
          order.reversed
          order.reversed?.should be_true
        end
      end

      context "from under_review" do
        it "returns true" do
          order.authorized
          order.under_review
          order.reversed
          order.reversed?.should be_true
        end
      end

      context "from picking" do
        it "returns true" do
          order.authorized
          order.picking
          order.reversed
          order.reversed?.should be_true
        end
      end

      context "from delivering" do
        it "returns true" do
          order.authorized
          order.picking
          order.delivering
          order.reversed
          order.reversed?.should be_true
        end
      end

      context "from delivered" do
        it "returns true" do
          order.authorized
          order.picking
          order.delivering
          order.delivered
          order.reversed
          order.reversed?.should be_true
        end
      end

      context "from not_delivered" do
        it "returns true" do
          order.authorized
          order.picking
          order.delivering
          order.not_delivered
          order.reversed
          order.reversed?.should be_true
        end
      end
    end

    context 'refunded' do
      it "returns true" do
        order.authorized
        order.under_review
        order.refunded
        order.refunded?.should be_true
      end

      context "from authorized" do
        it "returns true" do
          order.authorized
          order.refunded
          order.refunded?.should be_true
        end
      end

      context "from picking" do
        it "returns true" do
          order.authorized
          order.picking
          order.refunded
          order.refunded?.should be_true
        end
      end

      context "from delivering" do
        it "returns true" do
          order.authorized
          order.picking
          order.delivering
          order.refunded
          order.refunded?.should be_true
        end
      end

      context "from delivered" do
        it "returns true" do
          order.authorized
          order.picking
          order.delivering
          order.delivered
          order.refunded
          order.refunded?.should be_true
        end
      end

      context "from not_delivered" do
        it "returns true" do
          order.authorized
          order.picking
          order.delivering
          order.not_delivered
          order.refunded
          order.refunded?.should be_true
        end
      end
    end

    context "picking" do
      context "from authorized" do
        it "should set picking" do
          order.authorized
          order.picking
          order.picking?.should be_true
        end
      end
    end

    context "delivering" do
      context "from picking" do
        it "returns true" do
          order.authorized
          order.picking
          order.delivering
          order.delivering?.should be_true
        end
      end
    end

    context "delivered" do
      context "from delivering" do
        it "returns true" do
          order.authorized
          order.picking
          order.delivering
          order.delivered
          order.delivered?.should be_true
        end
      end
    end

    context "not delivered" do
      context "from delivering" do
        it "should set not_delivered" do
          order.authorized
          order.picking
          order.delivering
          order.not_delivered
          order.not_delivered?.should be_true
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
    let!(:order) { FactoryGirl.create(:authorized_order) }

    let!(:order_without_payment) do
      order = FactoryGirl.create :clean_order
      order.payments.destroy_all
      order
    end

    it 'should include the order with the payment' do
      described_class.with_payment.all.should include(order)
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
      order.authorized
      transition = order.order_state_transitions.last
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
        order = FactoryGirl.create(:order)
        order.update_attribute(:state, 'waiting_payment')
        waiting = Order.with_state("waiting_payment").map(&:state)
        expect(waiting).to have(1).item
        expect(waiting).to include("waiting_payment")
      end
    end

    context ".with_date_and_authorized" do

      it "returns orders on a specific date" do
        orders_today = Order.with_date_and_authorized(now)
        expect(orders_today).to have(1).item
        expect(orders_today.first).to eq(order)
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
          @past_order = FactoryGirl.create(:order)
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

  describe '#authorize_erp_payment' do
    let(:payment) { mock Payment }
    before do
      subject.stub(:erp_payment).and_return(payment)
    end

    it "calls payment method to authorize and notify" do
      payment.should_receive(:authorize_and_notify_if_is_a_billet)
      subject.authorize_erp_payment
    end
  end
end
