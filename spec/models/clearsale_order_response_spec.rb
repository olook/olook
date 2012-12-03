require 'spec_helper'

describe ClearsaleOrderResponse do
  context "'to_be_processed' query scenarios" do
    it "should return not processed response" do
      FactoryGirl.create(:clearsale_order_response, :processed => false)
      ClearsaleOrderResponse.to_be_processed.size.should eq(1)
    end

    it "shouldn't return processed responses" do
      FactoryGirl.create(:clearsale_order_response, :processed => true)
      ClearsaleOrderResponse.to_be_processed.should be_empty
    end

  end

  context "status checks" do
    let(:pending_response) {FactoryGirl.create(:clearsale_order_response, :processed => true, :status => :manual_analysis)}
    let(:accepted_response) {FactoryGirl.create(:clearsale_order_response, :processed => true, :status => :automatic_approval)}
    let(:rejected_response) {FactoryGirl.create(:clearsale_order_response, :processed => true, :status => :error)}

    it "should check if the response is pending" do      
      pending_response.has_pending_status?.should be_true
      accepted_response.has_pending_status?.should be_false
      rejected_response.has_pending_status?.should be_false
    end  

    it "should check if the response is accepted" do      
      pending_response.has_an_accepted_status?.should be_false
      accepted_response.has_an_accepted_status?.should be_true
      rejected_response.has_an_accepted_status?.should be_false
    end  

    it "should check if the response is rejected" do      
      pending_response.has_a_rejected_status?.should be_false
      accepted_response.has_a_rejected_status?.should be_false
      rejected_response.has_a_rejected_status?.should be_true
    end  

  end
end
