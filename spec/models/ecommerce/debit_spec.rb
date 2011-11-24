require "spec_helper"

describe Debit do

  subject { FactoryGirl.create(:debit) }

  context "attributes validation" do
    it{ should validate_presence_of :bank }
    it{ should validate_presence_of :receipt }
  end

  it "should return to_s version" do
    subject.to_s.should == "DebitoBancario"
  end
end
