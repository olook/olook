require 'spec_helper'

describe ClearsaleOrderResponse do
  context "'to_be_processed' query scenarios" do
    it "should return the pending response" do
      FactoryGirl.create(:clearsale_order_response, :processed => false, :status => :manual_analysis)
      ClearsaleOrderResponse.to_be_processed.size.should eq(1)
    end

    it "shouldn't return the pending response because the status isn't eligible for processing" do
      FactoryGirl.create(:clearsale_order_response, :processed => false, :status => :automatic_approval)
      ClearsaleOrderResponse.to_be_processed.should be_empty
    end

    it "shouldn't return anything as the only response available is processed already" do
      FactoryGirl.create(:clearsale_order_response, :processed => true, :status => :manual_analysis)
      ClearsaleOrderResponse.to_be_processed.should be_empty
    end  
  end

  context "status checks" do
    let(:response_to_be_processed) {FactoryGirl.create(:clearsale_order_response, :processed => true, :status => :manual_analysis)}
    let(:accepted_response) {FactoryGirl.create(:clearsale_order_response, :processed => true, :status => :automatic_approval)}
    let(:rejected_response) {FactoryGirl.create(:clearsale_order_response, :processed => true, :status => :error)}

    it "should check if the response has to be processed" do      
      response_to_be_processed.has_to_be_processed?.should be_true
      accepted_response.has_to_be_processed?.should be_false
      rejected_response.has_to_be_processed?.should be_false
    end  

    it "should check if the response is accepted" do      
      response_to_be_processed.has_an_accepted_status?.should be_false
      accepted_response.has_an_accepted_status?.should be_true
      rejected_response.has_an_accepted_status?.should be_false
    end  

    it "should check if the response is rejected" do      
      response_to_be_processed.has_a_rejected_status?.should be_false
      accepted_response.has_a_rejected_status?.should be_false
      rejected_response.has_a_rejected_status?.should be_true
    end  

  end
end
