# -*- encoding : utf-8 -*-
require 'spec_helper'

describe PurchaseTimeline::Helper do
  describe "#timeline_date_format" do
    it "should change the order date to date, formatted for timeline" do
      order = double("order", :created_at => Time.zone.parse('2007-02-10 15:30:45'))
      expected = "2007,02,10"
      helper.timeline_date_format(order.created_at).should == expected
    end
  end

  describe "#calculate_delivered_date" do
    it "should calculate the delivery estimation date for business days" do
      order = double("order", :created_at => Time.zone.parse('2012-07-13 15:30:45'))
      delivery_estimation = 3
      expected = Date.parse("2012-07-18")
      helper.calculate_delivered_date(order.created_at, delivery_estimation).should == expected
    end
  end


  describe "#timeline_delivered_date_format" do
    it "should format the delivered date for the timeline" do
      payment_date = Time.zone.parse('2012-07-13 15:30:45')
      delivery_time = 3
      expected = "2012,07,18"
      helper.timeline_delivered_date_format(payment_date, delivery_time).should == expected
    end
  end

  describe "#shipping_service_art" do
    it "should generate a image tag for the specific shipping service" do
      order = double("order")
      order.stub_chain(:freight, :shipping_service, :erp_code).and_return("TEX")
      expected = /<img.*tex.png.*/
      helper.shipping_service_art(order).match(expected)
    end
  end


end