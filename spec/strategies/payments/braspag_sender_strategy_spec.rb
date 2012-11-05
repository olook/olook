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

    it "should create an order" do
      subject.order_data.should be_true
    end

    it "should create an address" do
      subject.address_data.should be_true
    end

    it "should create a customer" do
      subject.customer_data.should be_true
    end

    it "should create a payment" do
      subject.payment_data.should be_true
    end

    it "should create authorize transaction" do
      subject.authorize_transaction_data.should be_true
    end

  end

end

