# -*- encoding : utf-8 -*-
require "spec_helper"

describe OrderStatus do
  let(:order) {  FactoryGirl.create(:order) }
  subject { OrderStatus.new(order) }

  context "order.not_delivered?" do
    it "should return status date for not-order-delivered" do
      order.completed
      order.prepared
      order.not_delivered
      subject.status.css_class.should == OrderStatus::STATUS["order-not-delivered"][0]
      subject.status.message.should   == OrderStatus::STATUS["order-not-delivered"][1]
    end
  end

  context "order.delivered?" do
    it "should return status date for order-delivered" do
      order.completed
      order.prepared
      order.delivered
      subject.status.css_class.should == OrderStatus::STATUS["order-delivered"][0]
      subject.status.message.should   == OrderStatus::STATUS["order-delivered"][1]
    end
  end

  context "order.prepared?" do
    it "should return status date for order-prepared" do
      order.completed
      order.prepared
      subject.status.css_class.should == OrderStatus::STATUS["order-prepared"][0]
      subject.status.message.should   == OrderStatus::STATUS["order-prepared"][1]
    end
  end

  context "order.reversed?" do
    it "should return status date for payment-made-failed" do
      order.under_review
      order.reversed
      subject.status.css_class.should == OrderStatus::STATUS["payment-made-failed"][0]
      subject.status.message.should   == OrderStatus::STATUS["payment-made-failed"][1]
    end
  end

  context "order.refunded?" do
    it "should return status date for payment-made-failed" do
      order.under_review
      order.refunded
      subject.status.css_class.should == OrderStatus::STATUS["payment-made-failed"][0]
      subject.status.message.should   == OrderStatus::STATUS["payment-made-failed"][1]
    end
  end

  context "order.completed?" do
    it "should return status date for payment-made-approved" do
      order.completed
      subject.status.css_class.should == OrderStatus::STATUS["payment-made-approved"][0]
      subject.status.message.should   == OrderStatus::STATUS["payment-made-approved"][1]
    end
  end

  context "order.canceled?" do
    it "should return status date for payment-made-denied" do
      order.canceled
      subject.status.css_class.should == OrderStatus::STATUS["payment-made-denied"][0]
      subject.status.message.should   == OrderStatus::STATUS["payment-made-denied"][1]
    end
  end

  context "order.requested?" do
    it "should return status date for order-requested when waiting_payment" do
      subject.status.css_class.should == OrderStatus::STATUS["order-requested"][0]
      subject.status.message.should   == OrderStatus::STATUS["order-requested"][1]
    end

    it "should return status date for order-requested when under_review" do
      order.under_review
      subject.status.css_class.should == OrderStatus::STATUS["order-requested"][0]
      subject.status.message.should   == OrderStatus::STATUS["order-requested"][1]
    end
  end
end
