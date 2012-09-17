# -*- encoding : utf-8 -*-
require "spec_helper"

describe Billet do

  let(:order) { FactoryGirl.create(:order) }
  subject { FactoryGirl.create(:billet, :order => order) }

  before :each do
    Resque.stub(:enqueue)
    Resque.stub(:enqueue_in)
  end

  context "expiration date" do
    subject { FactoryGirl.create(:billet) }

    context "expired" do
      before :each do
        subject.stub(:payment_expiration_date).and_return(Date.civil(2012, 2, 6))
      end

      it "should to be expired for 2012, 2, 9" do
        Date.stub(:current).and_return(Date.civil(2012, 2, 9))
        subject.expired?.should be_true
      end

      it "should to be expired for 2012, 2, 10" do
        Date.stub(:current).and_return(Date.civil(2012, 2, 10))
        subject.expired?.should be_true
      end

      it "should to be expired for 2012, 2, 10" do
        subject.stub(:payment_expiration_date).and_return(Date.civil(2012, 2, 10))
        Date.stub(:current).and_return(Date.civil(2012, 2, 16))
        subject.expired?.should be_true
      end
    end

    context "not expired" do
      before :each do
        subject.stub(:payment_expiration_date).and_return(Date.civil(2012, 2, 6))
      end

      it "should not to be expired for 2012, 2, 5" do
        Date.stub(:current).and_return(Date.civil(2012, 2, 5))
        subject.expired?.should be_false
      end

      it "should not to be expired for 2012, 2, 6" do
        Date.stub(:current).and_return(Date.civil(2012, 2, 6))
        subject.expired?.should be_false
      end

      it "should not to be expired for 2012, 2, 7" do
        Date.stub(:current).and_return(Date.civil(2012, 2, 7))
        subject.expired?.should be_false
      end

      it "should not to be expired for 2012, 2, 8" do
        Date.stub(:current).and_return(Date.civil(2012, 2, 8))
        subject.expired?.should be_false
      end

      it "should not to be expired for 2012, 2, 14" do
        subject.stub(:payment_expiration_date).and_return(Date.civil(2012, 2, 10))
        Date.stub(:current).and_return(Date.civil(2012, 2, 14))
        subject.expired?.should be_false
      end
    end
  end

  context "payment expiration date" do
    it "should set payment expiration date after create" do
      BilletExpirationDate.stub(:expiration_for_two_business_day).and_return(current_date = Date.current)
      billet = FactoryGirl.create(:billet)
      billet.payment_expiration_date.to_date.should == BilletExpirationDate.expiration_for_two_business_day
    end
  end

  it "should return to_s version" do
    subject.to_s.should == "BoletoBancario"
  end

  it "should return human to_s human version" do
    subject.human_to_s.should == "Boleto Bancário"
  end

  context "attributes validation" do
    subject { Billet.new }
    it{ should validate_presence_of :receipt }
  end
end
