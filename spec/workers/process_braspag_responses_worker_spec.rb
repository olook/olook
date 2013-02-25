# -*- encoding : utf-8 -*-
require 'spec_helper'

describe ProcessBraspagResponsesWorker do

  context "when payment does not exist" do

    let(:authorize_response) { FactoryGirl.create(:braspag_authorize_response, :identification_code => "invalid", :retries => 0) }
    let(:capture_response) { FactoryGirl.create(:braspag_capture_response, :identification_code => "invalid", :retries => 0) }

    it "should update authorize_response to processed with error" do
      BraspagAuthorizeResponse.stub_chain(:to_process).and_return([authorize_response])
      ProcessBraspagResponsesWorker.process_authorize_responses
      authorize_response.reload.retries.should eq(1)
      authorize_response.error_message.should eq("Pagamento não identificado.")
    end

    it "should update capture_response to processed with error" do
      BraspagAuthorizeResponse.stub_chain(:to_process).and_return([capture_response])
      ProcessBraspagResponsesWorker.process_capture_responses
      capture_response.reload.retries.should eq(1)
      capture_response.error_message.should eq("Pagamento não identificado.")
    end
  end

  context "when payment exists" do
    let(:payment) { FactoryGirl.create(:credit_card) }
    let(:authorize_response) { 
      FactoryGirl.create(:braspag_authorize_response, :identification_code => payment.identification_code) }
    let(:capture_response) { 
      FactoryGirl.create(:braspag_capture_response, :identification_code => payment.identification_code) }

    it "should call update_payment_status on authorize_response" do
      payment.identification_code =  authorize_response.identification_code
      Payment.stub(:find_by_identification_code).with(authorize_response.identification_code).and_return(payment)
      BraspagAuthorizeResponse.stub_chain(:to_process).and_return([authorize_response])
      authorize_response.should_receive(:update_payment_status).with(payment)
      ProcessBraspagResponsesWorker.perform
    end

    it "should call update_payment_status on capture_response" do
      payment.identification_code =  capture_response.identification_code
      Payment.stub(:find_by_identification_code).with(capture_response.identification_code).and_return(payment)      
      BraspagAuthorizeResponse.stub_chain(:to_process).and_return([capture_response])
      capture_response.should_receive(:update_payment_status).with(payment)
      ProcessBraspagResponsesWorker.perform
    end

  end
  
end