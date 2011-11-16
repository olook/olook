require "spec_helper"

describe PaymentResponse do
  subject { PaymentResponse.new }

  it "should build basic attributes" do
    response = {"ID"=>"2011", "Status"=>"Sucesso", "Token"=>"AXBT"}
    subject.build_attributes response
    subject.response_id.should == response["ID"]
    subject.response_status.should == response["Status"]
    subject.token.should == response["Token"]
  end
end
