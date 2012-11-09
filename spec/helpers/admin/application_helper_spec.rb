# -*- encoding : utf-8 -*-
require 'spec_helper'

describe ApplicationHelper do 

  context "should humanize the gateway" do
    it "when gateway is moip" do
      helper.humanize_gateway(1).should eq("Moip")
    end

    it "when gateway is braspag" do
      helper.humanize_gateway(2).should eq("Braspag")
    end

    it "when gateway is nil" do
      helper.humanize_gateway(nil).should eq(nil)
    end

  end

end