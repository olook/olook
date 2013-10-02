# -*- encoding : utf-8 -*-
require "spec_helper"

describe Debit do

  let(:order) { FactoryGirl.create(:order) }
  subject { FactoryGirl.create(:debit, :order => order) }

  it "should return to_s version" do
    subject.to_s.should == "DebitoBancario"
  end

  it "should return to_s human version" do
    subject.human_to_s.should == "Débito Bancário"
  end

  context "#schedule_cancellation" do
    it "schedules cancellation in 5 business hour from creation" do
      Timecop.freeze do
        Resque.should_receive(:enqueue_at).with(5.business_hour.from_now, Abacos::CancelOrder, order.number)
        subject.schedule_cancellation
      end
    end
  end

  context "expiration date" do
    it "should set payment expiration date after create" do
      Timecop.freeze do
        Debit.any_instance.stub(:build_payment_expiration_date).and_return(expiration_date = Debit::EXPIRATION_IN_MINUTES.days.from_now)
        subject.payment_expiration_date.should == expiration_date
      end
    end
  end

  context "attributes validation" do
    subject { Debit.new }
    it{ should validate_presence_of :bank }
    it{ should validate_presence_of :receipt }
  end
end
