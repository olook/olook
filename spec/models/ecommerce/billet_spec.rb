require "spec_helper"

describe Billet do

  subject { FactoryGirl.create(:billet) }

  it "should return to_s version" do
    subject.to_s.should == "BoletoBancario"
  end
end
