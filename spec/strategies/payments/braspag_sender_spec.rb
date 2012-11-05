require 'spec_helper'

describe Payments::BraspagSenderStrategy do
  let(:user) { FactoryGirl.create(:user) }
  let(:payment) {FactoryGirl.create(:payment)}
  let(:shipping_service) { FactoryGirl.create :shipping_service }
  let(:order) { FactoryGirl.create(:order, :user => user) }
  let(:credit_card) { FactoryGirl.create(:credit_card, :order => order) }
  let(:credit_card_with_response) { FactoryGirl.create(:credit_card_with_response) }
  let(:address) { FactoryGirl.create(:address, :user => user) }
  #let(:freight) { { :price => 12.34, :cost => 2.34, :delivery_time => 2, :shipping_service_id => shipping_service.id, :address_id => address.id} }
  let(:freight) { FactoryGirl.create(:freight, :address => address) }
  let(:cart) { FactoryGirl.create(:cart_with_items, :user => user) }
  let(:cart_service) { CartService.new({
    :cart => cart,
    :freight => freight,
  }) }
  let(:order_total) { 12.34 }

  it "should be initialize with success" do
    Payments::BraspagSenderStrategy.new(cart_service, payment).should be_true
  end

  context "with a valid class" do
    subject {Payments::BraspagSenderStrategy.new(cart_service, payment)}

    payment_data = mock("payment_data",
      :payment_method => Braspag::PAYMENT_METHOD[:braspag],
      :amount => 100.00,
      :transaction_type => "1",
      :currency => "BRL",
      :country => "BRA",
      :number_of_payments => 1,
      :payment_plan => "0",
      :transaction_type => "1",
      :holder_name => "John Doe",
      :card_number => "0000000000000001",
      :security_code => "123",
      :expiration_month => "05",
      :expiration_year => "2018"
      )

    it "should create an order" do
      subject.order_data.should be_true
    end

    it "should create an address" do
      subject.address_data(freight).should be_true
    end

    it "should create a customer" do
      subject.customer_data(user, address).should be_true
    end

    it "should create a payment" do
      subject.payment = credit_card
      subject.payment_data.should be_true
    end

    it "should create authorize transaction" do
      #subject.payment = credit_card
      #subject.payment.payments = 1
      order = subject.order_data
      #payment = subject.payment_data
      customer = subject.customer_data(user, address)
      subject.authorize_transaction(payment_data, order, customer).should be_true
    end

  end

end
