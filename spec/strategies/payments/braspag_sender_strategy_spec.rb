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
    :cart => cart
    # ,    :freight => freight,
  }) }
  let(:order_total) { 12.34 }

  before do
    Address.stub(:find_by_id!).and_return(address)
    cart_service.stub(:freight).and_return({:address => {:id => address.id}})
  end

  context "with a valid class" do
    subject {Payments::BraspagSenderStrategy.new(credit_card)}

    before :each do
      subject.credit_card_number = credit_card.credit_card_number
      OrderAnalysisService.any_instance.stub(:should_send_to_analysis?) {false}
      subject.cart_service = cart_service
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
      Payments::BraspagSenderStrategy.new(credit_card).should be_true
    end

    it "should set gateway" do
      subject.update_gateway_info
      subject.payment.gateway.should eq(2)
    end

    it "should return payment successful as TRUE" do
      subject.should_receive(:authorize).and_return({})
      subject.should_receive(:authorized_and_pending_capture?).and_return(:true)
      subject.send_to_gateway
      subject.payment_successful?.should eq(true)
    end

    it "should enqueue request on resque" do
      subject.should_receive(:send_authorization_request).and_return(:true)
      subject.send_to_gateway
    end

    context "process enqueued request" do
      it "should encrypt the credit card data for the given payment even if an exception is raised" do
        subject.stub(:web_service_data).and_raise(Exception)
        CreditCard.any_instance.should_receive(:encrypt_credit_card)
        expect {subject.send_authorization_request}.to raise_error{Exception}
      end
    end

  end

  context "processing response" do
    subject {Payments::BraspagSenderStrategy.new(credit_card)}

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

  context "#format_amount" do
    subject { Payments::BraspagSenderStrategy.new(credit_card) }

    it "returns 799 when value is 7,99" do
      subject.format_amount(7.99).should eq("799")
    end

    it "returns 7990 when value is 79,90" do
      subject.format_amount(79.90).should eq("7990")
    end

    it "returns 790 when value is 7,90" do
      subject.format_amount(7.90).should eq("790")
    end

    it "returns 10000 when value is 100" do
      subject.format_amount(100).should eq("10000")
    end

    it "returns 10000 when value is 100" do
      subject.format_amount(1000).should eq("100000")
    end

  end

  context "#authorized_and_pending_capture?" do
    subject { Payments::BraspagSenderStrategy.new(credit_card) }

    it "returns true when response is success and status is 1" do
      response = mock()
      response.stub(:success).and_return(true)
      response.stub(:status).and_return(1)
      subject.authorized_and_pending_capture?(response).should eq(true)
    end

    it "returns true when response is not success and status is 1" do
      response = mock()
      response.stub(:success).and_return(false)
      response.stub(:status).and_return(1)
      subject.authorized_and_pending_capture?(response).should eq(false)
    end

    it "returns true when response is success and status is not 1" do
      response = mock()
      response.stub(:success).and_return(true)
      response.stub(:status).and_return(2)
      subject.authorized_and_pending_capture?(response).should eq(false)
    end

    it "returns true when response is not success and status is not 1" do
      response = mock()
      response.stub(:success).and_return(false)
      response.stub(:status).and_return(2)
      subject.authorized_and_pending_capture?(response).should eq(false)
    end

  end

  context "#web_service_data" do
    subject { Payments::BraspagSenderStrategy.new(credit_card) }

    it "initializes webservice with a symbol" do
      Braspag::Webservice.should_receive(:new).with(:homologation)
      subject.web_service_data
    end

  end

  context "#payment_plan" do
    subject { Payments::BraspagSenderStrategy.new(credit_card) }

    it "returns '0' when number of payments is = 1" do
      subject.payment_plan(1).should eq("0")
    end

    it "returns '1' when number of payments is > 1" do
      subject.payment_plan(2).should eq("1")
      subject.payment_plan(3).should eq("1")
      subject.payment_plan(4).should eq("1")
      subject.payment_plan(50).should eq("1")
    end

  end

end

