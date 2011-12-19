require "spec_helper"

describe PaymentResponse do
  let (:response){{"ID"=>"2011", "Status"=>Payment::SUCCESSFUL_STATUS, "Token"=>"AXBT", "RespostaPagamentoDireto" => {"Status" => "EmAnalise"}}}
  subject { PaymentResponse.new }

  before :each do
    subject.build_attributes response
  end

  it "should build basic attributes" do
    subject.response_id.should == response["ID"]
    subject.response_status.should == response["Status"]
    subject.token.should == response["Token"]
  end

  it "should return true when sucess" do
    subject.success?.should eq(true)
  end

  it "should not return true when ssailure" do
    response = {"ID"=>"2011", "Status"=>Payment::FAILURE_STATUS, "Token"=>"AXBT"}
    subject.build_attributes response
    subject.success?.should_not eq(true)
  end

  it "should return the status" do
    subject.status.should == Payment::RESPONSE_STATUS["EmAnalise"]
  end
end
