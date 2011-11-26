require "spec_helper"

describe PaymentResponse do
  let (:response){{"ID"=>"2011", "Status"=>"Sucesso", "Token"=>"AXBT"}}
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

  it "should not return true when sucess" do
    response = {"ID"=>"2011", "Status"=>"Falha", "Token"=>"AXBT"}
    subject.build_attributes response
    subject.success?.should_not eq(true)
  end
end
