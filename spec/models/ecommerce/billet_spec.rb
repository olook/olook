require "spec_helper"

describe Billet do

  subject { FactoryGirl.create(:billet) }

  it {should validate_presence_of :receipt }

  it "should return to_s version" do
    subject.to_s.should == "BoletoBancario"
  end
end
