# -*- encoding : utf-8 -*-
require 'spec_helper'

describe LandingPagesHelper do
  describe "#button_position" do
    let(:landing) { double(:landing_page) }

    context "when page has no button position set" do
      it "returns an empty string" do
        landing.stub(:button_top).and_return(nil)
        landing.stub(:button_left).and_return(nil)

        helper.button_position(landing).should == ""
      end
    end

    context "when page has button top set" do
      it "returns css top attribute with value" do
        landing.stub(:button_top).and_return("123")
        landing.stub(:button_left).and_return(nil)

        helper.button_position(landing).should == "top:123px;"
      end
    end

    context "when page has button left set" do
      it "returns css let attribute with value" do
        landing.stub(:button_top).and_return(nil)
        landing.stub(:button_left).and_return("375")

        helper.button_position(landing).should == "left:375px;"
      end
    end

    context "when page has button left and button top set" do
      it "returns css top and left attibutes with corresponding values" do
        landing.stub(:button_top).and_return("123")
        landing.stub(:button_left).and_return("375")

        helper.button_position(landing).should == "top:123px;left:375px;"
      end
    end
  end
end