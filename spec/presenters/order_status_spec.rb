# -*- encoding : utf-8 -*-
require "spec_helper"

describe OrderStatus do
  before :each do
    Resque.stub(:enqueue)
    Resque.stub(:enqueue_in)
  end

  let!(:loyalty_program_credit_type) { FactoryGirl.create(:loyalty_program_credit_type) }
  let!(:invite_credit_type) { FactoryGirl.create(:invite_credit_type) }


  context "order.requested?" do
    let(:order) {  FactoryGirl.create(:clean_order) }
    subject { OrderStatus.new(order) }
    
    it "should return status date for order-requested when waiting_payment" do
      subject.status.css_class.should == OrderStatus::STATUS["order-requested"][0]
      subject.status.message.should   == OrderStatus::STATUS["order-requested"][1]
    end

    it "should return status date for order-requested when under_review" do
      order.under_review!
      subject.status.css_class.should == OrderStatus::STATUS["order-requested"][0]
      subject.status.message.should   == OrderStatus::STATUS["order-requested"][1]
    end
  end

  context "order.canceled?" do
    let(:order) {  FactoryGirl.create(:clean_order) }
    subject { OrderStatus.new(order) }

    it "should return status date for payment-made-denied" do
      order.canceled!
      subject.status.css_class.should == OrderStatus::STATUS["payment-made-denied"][0]
      subject.status.message.should   == OrderStatus::STATUS["payment-made-denied"][1]
    end
  end

  context "order.reversed?" do
    let(:order) {  FactoryGirl.create(:order_with_payment_authorized) }
    subject { OrderStatus.new(order) }
    
    it "should return status data for payment-made-failed" do
      order.under_review
      order.reversed
      subject.status.css_class.should == OrderStatus::STATUS["payment-made-failed"][0]
      subject.status.message.should   == OrderStatus::STATUS["payment-made-failed"][1]
    end
  end

  context "order.refunded?" do
    let(:order) {  FactoryGirl.create(:order_with_payment_authorized) }
    subject { OrderStatus.new(order) }
    
    it "should return status data for payment-made-failed" do
      order.under_review
      order.refunded
      subject.status.css_class.should == OrderStatus::STATUS["payment-made-failed"][0]
      subject.status.message.should   == OrderStatus::STATUS["payment-made-failed"][1]
    end
  end

  context "order.authorized?" do
    let(:order) {  FactoryGirl.create(:order_with_payment_authorized) }
    subject { OrderStatus.new(order) }
    
    it "should return status data for payment-made-authorized" do
      subject.status.css_class.should == OrderStatus::STATUS["payment-made-authorized"][0]
      subject.status.message.should   == OrderStatus::STATUS["payment-made-authorized"][1]
    end
  end

  context "order.picking?" do
    let(:order) {  FactoryGirl.create(:order_with_payment_authorized) }
    subject { OrderStatus.new(order) }
    
    it "should return status data for order-picking" do
      order.picking
      subject.status.css_class.should == OrderStatus::STATUS["order-picking"][0]
      subject.status.message.should   == OrderStatus::STATUS["order-picking"][1]
    end
  end

  context "order.delivering?" do
    let(:order) {  FactoryGirl.create(:order_with_payment_authorized) }
    subject { OrderStatus.new(order) }
    
    it "should return status data for order-delivering" do
      order.picking
      order.delivering
      subject.status.css_class.should == OrderStatus::STATUS["order-delivering"][0]
      subject.status.message.should   == OrderStatus::STATUS["order-delivering"][1]
    end
  end
  
  context "order.not_delivered?" do
    let(:order) {  FactoryGirl.create(:order_with_payment_authorized) }
    subject { OrderStatus.new(order) }
    
    it "should return status data for not-order-delivered" do
      order.picking
      order.delivering
      order.not_delivered
      subject.status.css_class.should == OrderStatus::STATUS["order-not-delivered"][0]
      subject.status.message.should   == OrderStatus::STATUS["order-not-delivered"][1]
    end
  end

  context "order.delivered?" do
    let(:order) {  FactoryGirl.create(:order_with_payment_authorized) }
    subject { OrderStatus.new(order) }
    
    it "should return status data for order-delivered" do
      order.picking
      order.delivering
      order.delivered
      subject.status.css_class.should == OrderStatus::STATUS["order-delivered"][0]
      subject.status.message.should   == OrderStatus::STATUS["order-delivered"][1]
    end
  end
end
