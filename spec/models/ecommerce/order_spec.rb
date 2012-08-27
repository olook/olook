# encoding: utf-8
require 'spec_helper'

describe Order do
  before do
    Resque.stub(:enqueue)
    Resque.stub(:enqueue_in)
  end

  subject { FactoryGirl.create(:clean_order)}
  let(:basic_shoe) { FactoryGirl.create(:basic_shoe) }
  let(:basic_shoe_35) { FactoryGirl.create(:basic_shoe_size_35, :product => basic_shoe) }
  let(:basic_shoe_37) { FactoryGirl.create(:basic_shoe_size_37, :product => basic_shoe) }
  let(:basic_shoe_40) { FactoryGirl.create(:basic_shoe_size_40, :product => basic_shoe) }

  let(:quantity) { 3 }
  let(:credits) { 1.89 }


  it { should belong_to(:user) }
  it { should belong_to(:cart) }
  it { should have_one(:used_coupon) }

  pending "coupons" do
    it "should decrement a standart coupon" do
      remaining_amount = 10
      order = FactoryGirl.create(:order)
      coupon = FactoryGirl.create(:standard_coupon, :remaining_amount => remaining_amount)
      order.create_used_coupon(:coupon => coupon)
      order.invalidate_coupon
      coupon.reload.remaining_amount.should == remaining_amount - 1
    end

    it "should increment a standart coupon" do
      remaining_amount = 10
      order = FactoryGirl.create(:order)
      coupon = FactoryGirl.create(:standard_coupon, :remaining_amount => remaining_amount)
      order.create_used_coupon(:coupon => coupon)
      order.use_coupon
      coupon.reload.used_amount.should == 1
    end

    it "should not decrement a unlimited coupon" do
      order = FactoryGirl.create(:order)
      coupon = FactoryGirl.create(:unlimited_coupon)
      order.create_used_coupon(:coupon => coupon)
      remaining_amount = coupon.remaining_amount
      order.invalidate_coupon
      coupon.reload.remaining_amount.should == remaining_amount
    end

    it "should increment a unlimited coupon" do
      order = FactoryGirl.create(:order)
      coupon = FactoryGirl.create(:unlimited_coupon)
      order.create_used_coupon(:coupon => coupon)
      remaining_amount = coupon.remaining_amount
      order.use_coupon
      coupon.reload.used_amount.should == 1
    end
  end

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
        subject.stub(:payment).and_return(nil)
        subject.installments.should == 1
      end
    end
    context "when there's a payment" do
      it "should return the number of installments of the payment" do
        subject.payment.stub(:payments).and_return(3)
        subject.installments.should == 3
      end
    end
  end

  context "ERP(abacos) integration" do
    context "when the order is waiting payment" do
      it "should enqueue a job to insert a order" do
        Resque.should_receive(:enqueue).with(Abacos::InsertOrder, subject.number)
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
        Resque.should_receive(:enqueue_in).with(20.minutes, Abacos::ConfirmPayment, subject.number)
        subject.authorized
      end
    end

    context "when the order is waiting payment" do
      xit "updates user credit" do
        Credit.any_instance.should_receive(:remove)
        subject(:credits => 10)
      end
    end
  end

  describe "State machine" do
    it "should set authorized" do
      subject.authorized
      subject.authorized?.should be_true
    end

    it "should set authorized" do
      subject.authorized
      subject.under_review
      subject.under_review?.should be_true
    end

    it "should set canceled" do
      subject.canceled
      subject.canceled?.should be_true
    end

    it "should set canceled given not_delivered" do
      subject.authorized
      subject.picking
      subject.delivering
      subject.not_delivered
      subject.canceled
      subject.canceled?.should be_true
    end

    it "should set canceled given in_the_cart" do
      subject.canceled
      subject.canceled?.should be_true
    end

    it "should set reversed" do
      subject.authorized
      subject.under_review
      subject.reversed
      subject.reversed?.should be_true
    end

    it "should set refunded" do
      subject.authorized
      subject.under_review
      subject.refunded
      subject.refunded?.should be_true
    end

    it "should set picking" do
      subject.authorized
      subject.picking
      subject.picking?.should be_true
    end

    it "should set delivering" do
      subject.authorized
      subject.picking
      subject.delivering
      subject.delivering?.should be_true
    end

    it "should set delivered" do
      subject.authorized
      subject.picking
      subject.delivering
      subject.delivered
      subject.delivered?.should be_true
    end

    it "should set not_delivered" do
      subject.authorized
      subject.picking
      subject.delivering
      subject.not_delivered
      subject.not_delivered?.should be_true
    end

    xit "should use coupon when authorized" do
      Coupon.any_instance.should_receive(:increment!).with(:used_amount, 1)
      subject.authorized
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
      order.payment.destroy
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
      subject.authorized
      transition = subject.order_state_transitions.last
      transition.event.should == "authorized"
      transition.from.should == "waiting_payment"
      transition.to.should == "authorized"
    end
  end

  pending "#update_user_credit" do
    before do
      subject.user = FactoryGirl.create(:member)
    end

    context "when a order has an associated credit" do
      it "removes this credit from the user" do
        subject.credits = BigDecimal.new("10.30")
        subject.save!

        Credit.should_receive(:remove).with(subject.credits, subject.user, subject)
        subject.update_user_credit
      end
    end

    context "when the order has no credit" do
      it "does not remove this credit from the user" do
        Credit.should_not_receive(:remove)
        subject.update_user_credit
      end
    end
  end

  describe "unrestricted order should accept products from vitrine" do
    subject { FactoryGirl.create(:clean_order)}

    it "should return true to add gift and normal products to the same cart" do
      subject.restricted?.should be_false
    end
  end

  describe "restricted order should accept products from vitrine" do
    subject { FactoryGirl.create(:restricted_order)}

    it "should be marked as restricted" do
      subject.restricted?.should be_true
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