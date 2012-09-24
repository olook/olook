# -*- encoding : utf-8 -*-
require "spec_helper"

describe SAC::AlertWorker do
  it "should perform alert for billet" do
    AlertForFraud.stub(:perform)
    AlertForBillet.should_receive(:perform).with("XPTO")
    described_class.perform(:order, "XPTO")
  end

  it "should perform alert for fraud" do
    AlertForBillet.stub(:perform)
    AlertForFraud.should_receive(:perform).with("XPTO")
    described_class.perform(:order, "XPTO")
  end
end