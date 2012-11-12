require 'spec_helper'

describe Payments::BraspagSenderStrategy do
  let(:user) { FactoryGirl.create(:user) }
  let(:shipping_service) { FactoryGirl.create :shipping_service }
  let(:order) { FactoryGirl.create(:order, :user => user) }
  let(:credit_card) { FactoryGirl.create(:credit_card, :order => order, :user => user, :cart => cart) }
  let(:address) { FactoryGirl.create(:address, :user => user) }
  let(:freight) { FactoryGirl.create(:freight, :address => address) }
  let(:cart) { FactoryGirl.create(:cart_with_items, :user => user) }
  let(:cart_service) { CartService.new({
    :cart => cart,
    :freight => freight,
  }) }
  let(:order_total) { 12.34 }

  context "with a valid class" do
    subject {Payments::BraspagSenderStrategy.new(cart_service, credit_card)}

    it "should be initialize with success" do
      Payments::BraspagSenderStrategy.new(cart_service, credit_card).should be_true
    end

    it "should set gateway" do
      subject.set_payment_gateway
      subject.payment.gateway.should eq(2)
    end

    it "should return payment successful as TRUE" do
      subject.payment_successful?.should eq(true)
    end

    it "should enqueue request on resque" do
      Resque.should_receive(:enqueue).with(Braspag::GatewaySenderWorker, subject.payment.id)
      subject.stub(:set_payment_gateway){nil}
      subject.send_to_gateway
    end

  end

end

