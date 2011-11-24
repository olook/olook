require "spec_helper"

describe Billet do

  subject { FactoryGirl.create(:billet) }
  let(:billet_printed) { "3" }
  let(:authorized) { "1" }
  let(:completed) { "4" }
  let(:under_review) { "6" }

  it "should return to_s version" do
    subject.to_s.should == "BoletoBancario"
  end

  describe "state machine" do
    it "should set billet_printed" do
      subject.set_state(billet_printed)
      subject.billet_printed?.should eq(true)
    end

    it "should set authorized" do
      subject.set_state(billet_printed)
      subject.set_state(authorized)
      subject.authorized?.should eq(true)
    end

    it "should set completed" do
      subject.set_state(billet_printed)
      subject.set_state(authorized)
      subject.set_state(completed)
      subject.completed?.should eq(true)
    end

    it "should set under_review" do
      subject.set_state(billet_printed)
      subject.set_state(authorized)
      subject.set_state(under_review)
      subject.under_review?.should eq(true)
    end

    it "should set completed given under_review" do
      subject.set_state(billet_printed)
      subject.set_state(authorized)
      subject.set_state(under_review)
      subject.set_state(completed)
      subject.completed?.should eq(true)
    end
  end
end
