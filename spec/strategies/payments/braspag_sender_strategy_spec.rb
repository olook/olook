require 'spec_helper'

describe Payments::BraspagSenderStrategy do
  let(:shipping_service) { FactoryGirl.create :shipping_service }
  let(:user) { FactoryGirl.create(:user) }
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

    before :each do
      subject.credit_card_number = credit_card.credit_card_number
      OrderAnalysisService.any_instance.stub(:should_send_to_analysis?) {false}
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

    it "should be initialize with success" do
      Payments::BraspagSenderStrategy.new(cart_service, credit_card).should be_true
    end

    it "should set gateway" do
      subject.update_gateway_info
      subject.payment.gateway.should eq(2)
    end

    it "should return payment successful as TRUE" do
      Resque.should_receive(:enqueue_in).with(2.minutes, Braspag::GatewaySenderWorker, subject.payment.id)
      subject.stub(:set_payment_gateway){nil}
      subject.send_to_gateway
      subject.payment_successful?.should eq(true)
    end

    it "should enqueue request on resque" do
      Resque.should_receive(:enqueue_in).with(2.minutes, Braspag::GatewaySenderWorker, subject.payment.id)
      subject.stub(:set_payment_gateway){nil}
      subject.send_to_gateway
    end

    context "process enqueued request" do
      it "should encrypt the credit card data for the given payment even if an exception is raised" do
        subject.stub(:web_service_data).and_raise(Exception)
        CreditCard.any_instance.should_receive(:encrypt_credit_card)
        expect {subject.process_enqueued_request}.to raise_error{Exception}
      end
    end

  end

  context "processing response" do
    subject {Payments::BraspagSenderStrategy.new(cart_service, credit_card)}

    before :each do
      subject.credit_card_number = credit_card.credit_card_number
      OrderAnalysisService.any_instance.stub(:should_send_to_analysis?) {false}
    end

    it "should create a correct failure response" do
      authorize_transaction_result = {:correlation_id => "1234567890", :error_report_data_collection => ["error_report_1", "error_report_2"]}
      authorization_response = subject.create_failure_authorize_response(authorize_transaction_result)
      authorization_response.correlation_id.should eq("1234567890")
      authorization_response.error_message.should eq("[\"error_report_1\", \"error_report_2\"]")
      authorization_response.success.should eq(false)
    end

    it "should create a failure BraspagAuthorizeResponse on database" do
      authorize_transaction_result = {:correlation_id => "1234567890", :error_report_data_collection => ["error_report_1", "error_report_2"]}
      expect {
        subject.create_failure_authorize_response(authorize_transaction_result)
      }.to change(BraspagAuthorizeResponse, :count).by(1)
    end

    it "should create a failure BraspagCaptureResponse on database" do
      capture_transaction_result = {:correlation_id => "1234567890", :error_report_data_collection => ["error_report_1", "error_report_2"]}
      expect {
        subject.create_failure_capture_response(capture_transaction_result)
      }.to change(BraspagCaptureResponse, :count).by(1)
    end

    it "should create a correct success response" do
      authorize_transaction_result =  {
        :correlation_id => "1234567890",
        :order_data => {:order_id => "123", :braspag_order_id => "456"},
        :payment_data_collection => { :payment_data_response => {
        :braspag_transaction_id => "555888", :amount => "500", :payment_method =>
        "997", :acquirer_transaction_id => "999888", :authorization_code => "987",
        :return_code => "1", :return_message => "Success", :status => "0",
        :credit_card_token => "444555666"} }}
      authorization_response = subject.create_success_authorize_response(authorize_transaction_result)
      authorization_response.correlation_id.should eq("1234567890")
      authorization_response.identification_code.should eq("123")
      authorization_response.braspag_order_id.should eq("456")
      authorization_response.braspag_transaction_id.should eq("555888")
      authorization_response.amount.should eq("500")
      authorization_response.payment_method.should eq(997)
      authorization_response.acquirer_transaction_id.should eq("999888")
      authorization_response.authorization_code.should eq("987")
      authorization_response.return_code.should eq("1")
      authorization_response.return_message.should eq("Success")
      authorization_response.status.should eq(0)
      authorization_response.credit_card_token.should eq("444555666")
    end

    it "should create a failure BraspagAuthorizeResponse on database" do
      authorize_transaction_result =  {
        :correlation_id => "1234567890",
        :order_data => {:order_id => "123", :braspag_order_id => "456"},
        :payment_data_collection => { :payment_data_response => {
        :braspag_transaction_id => "555888", :amount => "500", :payment_method =>
        "997", :acquirer_transaction_id => "999888", :authorization_code => "987",
        :return_code => "1", :return_message => "Success", :status => "0",
        :credit_card_token => "444555666"} }}
      expect {
        subject.create_success_authorize_response(authorize_transaction_result)
      }.to change(BraspagAuthorizeResponse, :count).by(1)
    end

    it "should create a failure BraspagCaptureResponse on database" do
      capture_transaction_result = {:correlation_id => "123456",
          :transaction_data_collection => {:transaction_data_response => {:braspag_transaction_id =>"12314341",
          :acquirer_transaction_id => "12331321",
          :amount => "500",
          :authorization_code => "123",
          :return_code => "1",
          :return_message => "Success",
          :status => "0"}} }

      expect {
        subject.create_success_capture_response(capture_transaction_result, "123312")
      }.to change(BraspagCaptureResponse, :count).by(1)
    end

  end

end

