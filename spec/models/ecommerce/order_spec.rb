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

  context "coupons" do
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

    it "should generate a identification code" do
      order = FactoryGirl.create(:order)
      order.identification_code.should_not be_nil
    end
  end

  context 'in a order with items' do
    let(:items_total) { basic_shoe_35.price + (quantity * basic_shoe_40.price) }
    before :each do
      # FIXME after the variant.retail_price issue is fixed, remove this workaround to have a product.retail_price with the proper value
      basic_shoe_35.product.stub(:retail_price).and_return(123.45)
      basic_shoe_37.product.stub(:retail_price).and_return(124.19)
      basic_shoe_40.product.stub(:retail_price).and_return(125.45)
      subject.add_variant(basic_shoe_35)
      subject.add_variant(basic_shoe_40, quantity)
    end

    describe '#line_items_total' do
      it 'should calculate the total' do
        expected = items_total
        subject.line_items_total.should == expected
      end
    end

    describe "#total_discount" do
      it "should return all discounts" do
        subject.stub(:credits).and_return(credits = 9.09)
        subject.stub(:discount_from_coupon).and_return(coupon = 8.36)
        subject.total_discount.should == credits + coupon
      end
    end

    describe "#max_credit_value" do
      context "when using coupons should ignore the promotion" do
        it "should return the order total deducted the minimum value and the promotion discount." do
          subject.stub(:line_items_total).and_return(total = 100.00)
          subject.stub(:discount_from_coupon).and_return(coupon = 10.00)
          subject.stub(:discount_from_promotion).and_return(promo = 20.00)
          subject.max_credit_value.should == total - Payment::MINIMUM_VALUE - coupon

        end
      end

      context "when using coupons should ignore the promotion" do
        it "should return the order total deducted the minimum value and the coupon discount." do
          subject.stub(:line_items_total).and_return(total = 100.00)
          subject.stub(:discount_from_coupon).and_return(coupon = 0.00)
          subject.stub(:discount_from_promotion).and_return(promo = 20.00)
          subject.max_credit_value.should == total - Payment::MINIMUM_VALUE - promo
        end
      end
    end

    describe "#update_credits!" do
      it "should update the credits if a discount or promotion changed the maximal value." do
          subject.stub!(:max_credit_value).and_return(50.00)
          subject.credits = 100.00
          subject.credits.should == 50.00
          subject.stub!(:max_credit_value).and_return(30.00)
          subject.update_credits!
          subject.credits.should == 30.00
      end
    end

    describe "#credits" do
      context "when the credit is smaller than the max allowed" do
        it "should return the credit amount asked by the user" do
          subject.stub!(:max_credit_value).and_return(150.00)
          subject.credits = 100.00
          subject.credits.should == 100.00
        end
      end

      context "when the credit is bigger than the max allowed" do
        it "should return the max credit amount" do
          subject.stub!(:max_credit_value).and_return(50.00)
          subject.credits = 100.00
          subject.credits.should == 50.00
        end
      end

      it 'should return 0 if credits is nil' do
        subject.credits = nil
        subject.credits.should == 0
      end
    end

    describe "#discount_from_coupon" do
      context "with a used_coupon" do
        it "should return the value in Reais" do
          coupon = FactoryGirl.create(:standard_coupon)
          subject.create_used_coupon(:coupon => coupon)
          subject.discount_from_coupon.should == coupon.value
        end

        it "should return the value in Percentage" do
          coupon = FactoryGirl.create(:percentage_coupon)
          subject.create_used_coupon(:coupon => coupon)
          percent_value = (coupon.value * subject.line_items_total) / 100
          subject.discount_from_coupon.should == percent_value
        end
      end

      context "without a used_coupon" do
        it "should return 0" do
          subject.discount_from_coupon.should == 0
        end
      end
    end

    describe "#total" do
      context "without coupon" do
        it "should return the total discounting the credits" do
          credits = 11.09
          subject.stub(:credits).and_return(credits)
          expected = items_total - credits
          subject.total.should == expected
        end

        it "should return the total without discounting credits if it doesn't have any" do
          expected = items_total
          subject.total.should == expected
        end
      end

      context "with a coupon" do
        it "should return the total discounting the credits and coupons" do
          credits = 11.09
          coupon = FactoryGirl.create(:standard_coupon)
          subject.create_used_coupon(:coupon => coupon)
          expected = items_total - credits - coupon.value
          subject.stub(:credits).and_return(credits)
          subject.total.should == expected
        end
      end
    end

    describe '#total_with_freight' do
      it "should return the total with freight" do
        subject.stub(:credits).and_return(11.0)
        subject.stub(:freight_price).and_return(22.0)
        expected = items_total - 11.0 + 22.0
        subject.total_with_freight.should be_within(0.001).of(expected)
      end

      it "should return the same value as #total if there's no freight" do
        subject.stub(:credits).and_return(11.0)
        subject.stub(:freight_price).and_return(0)
        subject.total_with_freight.should be_within(0.001).of(items_total - 11)
      end
    end
  end

  context "in an order without items" do
    it "#line_items_total should be zero" do
      subject.line_items_total.should == 0
    end

    context 'with free freight' do
      before(:each) do
        subject.stub(:freight_price).and_return(0)
      end

      it "#total should be zero" do
        subject.total.should == Payment::MINIMUM_VALUE
      end

      it "#total_with_freight should be the value of the freight" do
        subject.total_with_freight.should == Payment::MINIMUM_VALUE
      end
    end

    context 'without free freight' do
      it "#total should be zero" do
        subject.total.should == 0
      end
      it "#total_with_freight should be the value of the freight" do
        subject.total_with_freight.should == subject.freight.price
      end
    end
  end

  context "inventory update" do
    it "should decrement the inventory for each item" do
      basic_shoe_35_inventory = basic_shoe_35.inventory
      basic_shoe_40_inventory = basic_shoe_40.inventory
      subject.add_variant(basic_shoe_35, quantity)
      subject.add_variant(basic_shoe_40, quantity)
      subject.decrement_inventory_for_each_item
      basic_shoe_35.reload.inventory.should == basic_shoe_35_inventory - quantity
      basic_shoe_40.reload.inventory.should == basic_shoe_40_inventory - quantity
    end

    it "should increment the inventory for each item" do
      basic_shoe_35.increment!(:inventory, quantity)
      basic_shoe_40.increment!(:inventory, quantity)
      basic_shoe_35_inventory = basic_shoe_35.inventory
      basic_shoe_40_inventory = basic_shoe_40.inventory
      subject.add_variant(basic_shoe_35, quantity)
      subject.add_variant(basic_shoe_40, quantity)
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

  describe "ERP(abacos) integration" do
    context "when the order is waiting payment" do
      it "should enqueue a job to insert a order" do
        Resque.should_receive(:enqueue).with(Abacos::InsertOrder, subject.number)
      end

      it "updates order purchased_at with the current time" do
        time = DateTime.new(2012,5,10,23,59,59)
        Time.stub(:now).and_return(time)
        order = FactoryGirl.create(:clean_order)
        order.purchased_at.should eq(time)
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
      it "updates user credit" do
        order = FactoryGirl.build(:clean_order)
        order.should_receive(:update_user_credit)
        order.save
      end
    end
  end

  describe "State machine" do
    it "has waiting_payment as initial state" do
      subject.waiting_payment?.should be_true
    end

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

    it "should enqueue a OrderStatusWorker in any transation with a payment" do
      Resque.should_receive(:enqueue).with(OrderStatusWorker, subject.id)
      subject.waiting_payment?
    end

    it "should enqueue a OrderStatusWorker in any transation with a payment" do
      Resque.should_receive(:enqueue).with(OrderStatusWorker, subject.id)
      subject.authorized
    end

    it "should use coupon when authorized" do
      subject.should_receive(:use_coupon)
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
    let!(:clean_order) do
      order = FactoryGirl.create :clean_order
      order.payment.destroy
      order
    end

    it 'should include the order with the payment' do
      described_class.with_payment.all.should include(order_with_payment)
    end
    it 'should not include the order without the payment' do
      described_class.with_payment.all.should_not include(clean_order)
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

  describe "#update_user_credit" do
    before do
      subject.user = FactoryGirl.create(:member)
    end

    context "when a order has an associated credit" do
      it "removes this credit from the user" do
        subject.stub(:line_items_total).and_return(50.00)
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

end
