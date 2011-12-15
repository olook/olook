# -*- encoding : utf-8 -*-
require "spec_helper"

describe Debit do

  let(:order) { FactoryGirl.create(:order) }
  subject { FactoryGirl.create(:debit, :order => order) }
  let(:canceled) { "5" }
  let(:authorized) { "1" }
  let(:completed) { "4" }
  let(:under_review) { "8" }

  context "expiration date" do
    it "should set payment expiration date after create" do
      Debit.any_instance.stub(:build_payment_expiration_date).and_return(expiration_date = Debit::EXPIRATION_IN_MINUTES.days.from_now)
      debit = FactoryGirl.create(:debit)
      debit.payment_expiration_date.should == expiration_date
    end
  end

  context "status" do
    it "should return nil with a invalid status" do
      invalid_status = '0'
      subject.set_state(invalid_status).should be(nil)
    end
  end

  context "attributes validation" do
    subject { Debit.new }
    it{ should validate_presence_of :bank }
    it{ should validate_presence_of :receipt }
  end

  it "should return to_s version" do
    subject.to_s.should == "DebitoBancario"
  end

  it "should return to_s human version" do
    subject.human_to_s.should == "Débito Bancário"
  end

  describe "order state machine" do
    it "should set canceled for order" do
      subject.canceled
      subject.order.canceled?.should eq(true)
    end

    it "should set authorized for order" do
      subject.authorized
      subject.order.authorized?.should eq(true)
    end

    it "should not change the order status from authorized when the payment is completed" do
      subject.authorized
      subject.completed
      subject.order.authorized?.should eq(true)
    end

    it "should not change the order status from under review when the payment is completed after under review" do
      subject.authorized
      subject.under_review
      subject.completed
      subject.order.under_review?.should eq(true)
    end

    it "should set waiting_payment for order" do
      subject.authorized
      subject.under_review
      subject.order.under_review?.should eq(true)
    end

    it "should set under_review for order" do
      subject.authorized
      subject.under_review
      subject.order.under_review?.should eq(true)
    end

   it "should set refunded for order" do
      subject.authorized
      subject.under_review
      subject.refunded
      subject.order.refunded?.should eq(true)
    end
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

    it "should set refunded" do
      subject.authorized
      subject.under_review
      subject.refunded
      subject.refunded?.should eq(true)
    end
  end
end
