# -*- encoding : utf-8 -*-
require 'spec_helper'

describe ProcessBraspagResponsesWorker do

  context "when payment does not exist" do

    let(:authorize_response) { FactoryGirl.create(:braspag_authorize_response, :order_id => "invalid") }
    let(:capture_response) { FactoryGirl.create(:braspag_capture_response, :order_id => "invalid") }

    it "should update authorize_response to processed with error" do
      BraspagAuthorizeResponse.stub_chain(:to_process, :find_each).and_return([authorize_response])
      ProcessBraspagResponsesWorker.perform
      authorize_response.reload.processed.should eq(true)
      authorize_response.error_message.should eq("Pagamento não identificado.")
    end

    it "should update capture_response to processed with error" do
      ProcessBraspagResponsesWorker.perform
      capture_response.reload.processed.should eq(true)
      capture_response.error_message.should eq("Pagamento não identificado.")
    end
  end

  context "when payment exists" do
    let(:payment) { FactoryGirl.create(:credit_card) }
    let(:authorize_response) { 
      FactoryGirl.create(:braspag_authorize_response, :order_id => payment.identification_code) }
    let(:capture_response) { 
      FactoryGirl.create(:braspag_capture_response, :order_id => payment.identification_code) }

    it "should call update_payment_status on authorize_response" do
      payment.identification_code =  authorize_response.order_id
      Payment.stub(:find_by_identification_code).with(authorize_response.order_id).and_return(payment)
      BraspagAuthorizeResponse.stub_chain(:to_process, :find_each).and_return([authorize_response])
      authorize_response.should_receive(:update_payment_status).with(payment)
      ProcessBraspagResponsesWorker.perform
    end

    it "should call update_payment_status on capture_response" do
      payment.identification_code =  capture_response.order_id
      Payment.stub(:find_by_identification_code).with(capture_response.order_id).and_return(payment)      
      BraspagCaptureResponse.stub_chain(:to_process, :find_each).and_return([capture_response])
      capture_response.should_receive(:update_payment_status).with(payment)
      ProcessBraspagResponsesWorker.perform
    end

  end
  
end