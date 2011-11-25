require "spec_helper"

describe Debit do

  subject { FactoryGirl.create(:debit) }
  let(:canceled) { "5" }
  let(:authorized) { "1" }
  let(:completed) { "4" }
  let(:under_review) { "8" }

  context "status" do
    it "should return nil with a invalid status" do
      invalid_status = '0'
      subject.set_state(invalid_status).should be(nil)
    end
  end

  context "attributes validation" do
    it{ should validate_presence_of :bank }
    it{ should validate_presence_of :receipt }
  end

  it "should return to_s version" do
    subject.to_s.should == "DebitoBancario"
  end

  describe "state machine" do
    it "should set canceled" do
      subject.set_state(canceled)
      subject.canceled?.should eq(true)
    end

    it "should set authorized" do
      subject.set_state(authorized)
      subject.authorized?.should eq(true)
    end

    it "should set completed" do
      subject.set_state(authorized)
      subject.set_state(completed)
      subject.completed?.should eq(true)
    end

    it "should set under_review" do
      subject.set_state(authorized)
      subject.set_state(under_review)
      subject.under_review?.should eq(true)
    end

    it "should set completed given under_review" do
      subject.set_state(authorized)
      subject.set_state(under_review)
      subject.set_state(completed)
      subject.completed?.should eq(true)
    end
  end
end
