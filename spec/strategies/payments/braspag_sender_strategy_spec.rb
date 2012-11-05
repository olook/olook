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

    order_data = Braspag::Order.new(0006)

    address_data = Braspag::AddressBuilder.new.with_street("Rua de Casa").with_number("123").with_complement("").with_district("Pinheiros").with_zip_code("05425-070").with_city("Sao Paulo").with_state("SP").with_country("Brasil").build

    customer = Braspag::CustomerBuilder.new.with_customer_id("1234").with_customer_name("Matheus").with_customer_email("matheus.bodo@olook.com.br").with_customer_address(address_data).with_delivery_address(address_data).build

    payment_request = Braspag::CreditCardBuilder.new.with_payment_method(Braspag::PAYMENT_METHOD[:braspag]).with_amount("500").with_transaction_type("1").with_currency("BRL").with_country("BRA").with_number_of_payments(1).with_payment_plan("0").with_transaction_type("1").with_holder_name("Comprador Teste").with_card_number("0000000000000001").with_security_code("123").with_expiration_month("05").with_expiration_year("2018").build

    request = Braspag::AuthorizeTransactionRequestBuilder.new.with_request_id("00000000-0000-0000-0000-000000000007").for_order(order_data).for_customer(customer).with_payment_request(payment_request).build

    webservice = Braspag::Webservice.new(:homolog)

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
      subject.authorize_transaction_data(payment_request, order_data, customer).should be_true
    end

    it "should send to gateway" do

    end

    it "should set environment" do

    end

  end

  context "processing response" do
    subject {Payments::BraspagSenderStrategy.new(cart_service, payment)}

    it "should validate if the result is success" do
      subject.success_result?({:success => "true"}).should eq(true)
    end

    it "should validate if the result is not success" do
      subject.success_result?({:success => "false"}).should eq(false)
    end

    it "should create a correct failure response" do
      authorize_transaction_result = {:correlation_id => "1234567890", :error_report_data_collection => ["error_report_1", "error_report_2"]}
      authorization_response = subject.create_failure_authorize_response(authorize_transaction_result)
      authorization_response.correlation_id.should eq("1234567890")
      authorization_response.error_message.should eq("[\"error_report_1\", \"error_report_2\"]")
      authorization_response.success.should eq(false)
    end

    it "should create a failure AuthorizeResponse on database" do
      authorize_transaction_result = {:correlation_id => "1234567890", :error_report_data_collection => ["error_report_1", "error_report_2"]}
      expect {
        subject.create_failure_authorize_response(authorize_transaction_result)
      }.to change(AuthorizeResponse, :count).by(1)
    end

  end

end

