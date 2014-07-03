require "spec_helper"

describe PaymentBuilder do

  let(:user) { FactoryGirl.create(:user) }
  let(:order) { FactoryGirl.create(:order, gross_amount: BigDecimal("100.00"), user: user) }
  let(:credit_card) { FactoryGirl.create(:credit_card, :order => order, user: user) }
  let(:credit_card_with_response) { FactoryGirl.create(:credit_card_with_response) }
  let(:billet) { FactoryGirl.create(:billet) }
  let(:debit) { FactoryGirl.create(:debit) }

  let(:address) { FactoryGirl.create(:address, :user => user) }
  let(:cart) { FactoryGirl.create(:cart_with_items, :user => user) }
  let(:shipping_service) { FactoryGirl.create :shipping_service }
  let(:freight) { { :price => 12.34, :cost => 2.34, :delivery_time => 2, :shipping_service_id => shipping_service.id, :address_id => address.id} }
  let(:cart_service) { CartService.new({ :cart => cart }) }
  let(:moip_sender_strategy) {
    _mock = double(Payments::MoipSenderStrategy, {
    :respond_to? => true,
    :payment_successful? => true,
    :return_code => 200
    })
    _mock
  }

  let(:session_params) { { "referer" => "http://localhost:3000/registrar" } }
  let(:order_total) { 12.34 }

  subject { PaymentBuilder.new(:cart_service => cart_service, :payment => credit_card, :gateway_strategy => moip_sender_strategy, :tracking_params => session_params) }

  before :each do

    Airbrake.stub(:notify)
    cart_service.stub(:total => 10)
    cart.stub(:total_liquidation_discount => 0)
    cart.stub(:total_promotion_discount => 0)
  end

  context "#process!" do
    it "receives a payment object from the gateway" do
      payment = double(Payment)
      moip_sender_strategy.should_receive(:send_to_gateway).and_return(payment)
      moip_sender_strategy.should_receive(:return_code).and_return(nil)
      subject.process!
    end

    context "on success" do
      before :each do
        subject.gateway_strategy.stub(:payment_successful?).and_return(true)
        subject.gateway_strategy.stub(:send_to_gateway).and_return(subject.payment)
        moip_sender_strategy.stub(:payment_successful?).and_return(true)
        moip_sender_strategy.stub(:send_to_gateway).and_return(subject.payment)
      end

      it "assigns the order to the payment object" do
        cart_service.should_receive(:generate_order!).and_return(order)
        subject.process!
        subject.payment.order.should == order
      end

      it "should return a structure with status and a payment" do
        CartService.any_instance.should_receive(:freight).any_number_of_times.and_return(freight)
        response = subject.process!
        response.status.should == Payment::SUCCESSFUL_STATUS
        response.payment.should == credit_card
      end

      it "should decrement the inventory for each item" do
        cart_service.should_receive(:generate_order!).and_return(order)
        quantity = 1
        basic_shoe_35 = FactoryGirl.create(:basic_shoe_size_35, number: '35IN')
        order.line_items.create(
          :variant_id => basic_shoe_35.id,
          :quantity => quantity)
        expect {
          subject.process!
        }.to change { basic_shoe_35.reload.inventory }.by(-1)
      end

      context "cancellation pre-scheduling (to automatically free inventory if payment isn't made)" do
        context "credit card" do
          before do
            moip_sender_strategy.should_receive(:return_code).and_return(nil)
          end

          it "doesn't pre-schedule order cancellation" do
            subject.payment.should_not_receive(:schedule_cancellation)
            subject.process!
          end
        end
      end
    end

    context "on failure" do
      before :each do
        moip_sender_strategy.should_receive(:send_to_gateway)
        moip_sender_strategy.should_receive(:payment_successful?).and_return(false)
        moip_sender_strategy.should_receive(:return_code).and_return('58')
        subject.stub(:send_payment!)
      end

      it "should return a structure with failure status and without a payment when the gateway comunication fail " do
        subject.payment.stub(:gateway_response_status).and_return(Payment::FAILURE_STATUS)
        subject.stub_chain(:set_payment_url!).and_return(subject.payment)
        returned_value = subject.process!
        returned_value.status.should == Payment::FAILURE_STATUS
        returned_value.payment.should be_nil
      end

      it "should return a structure with failure status and without a payment" do
        subject.payment.stub(:gateway_response_status).and_return(Payment::SUCCESSFUL_STATUS)
        subject.payment.stub(:gateway_transaction_status).and_return(Payment::CANCELED_STATUS)
        subject.stub_chain(:set_payment_url!).and_return(subject.payment)
        returned_value = subject.process!
        returned_value.status.should == Payment::FAILURE_STATUS
        returned_value.payment.should be_nil
      end

      it "should return a structure with failure status and without a payment" do
        subject.stub(:send_payment!).and_raise(Exception)
        returned_value = subject.process!
        returned_value.status.should == Payment::FAILURE_STATUS
        returned_value.payment.should be_nil
      end
    end
  end

  describe "should_create_payment_for?" do

    context "when payment is greater that zero" do
       it "returns true" do
          expect(subject.should_create_payment_for?(10.0)).to be_true
       end
    end

    context "when payment is zero" do
       it "returns false" do
          expect(subject.should_create_payment_for?(0)).to be_false
       end
    end

  end

  describe "#create_payment_for" do
    context "when should create payment" do

      context "when payment isn't a credit" do

        it "receives create_payment method" do
          subject.should_receive(:should_create_payment_for?).and_return(true)
          subject.should_receive(:create_payment)
          subject.create_payment_for(10.0, OlookletPayment)
        end

      end

      context "when payment is a credit" do

        it "receives create_credit_payment method" do
          subject.should_receive(:should_create_payment_for?).and_return(true)
          subject.should_receive(:create_payment)
          subject.create_payment_for(10.0, CreditPayment, :loyalty_program)
        end

      end

    end

    context "when shouldn't create payment" do

      it "doesn't receive create_payment_method" do
        subject.should_not_receive(:create_payment)
        subject.should_not_receive(:create_credit_payment)
        subject.create_payment_for(0, OlookletPayment)
      end

    end

  end

  describe "#create_payment" do

    it "creates a payment" do
      OlookletPayment.should_receive(:create!)
      subject.should_receive(:change_state_of)
      subject.create_payment(BigDecimal("10.0"), OlookletPayment, {})
    end

  end

  describe "#create_credit_payment" do
    let!(:credit_type) { FactoryGirl.build(:credit_type) }
    it "creates a credit payment" do
      CreditPayment.should_receive(:create!)
      CreditType.should_receive(:find_by_code!).and_return(credit_type)
      subject.should_receive(:change_state_of)
      subject.create_payment(BigDecimal("10.0"), CreditPayment, {:credit => :loyalty_program})
    end
  end

 end
