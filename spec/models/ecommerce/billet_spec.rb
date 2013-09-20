# -*- encoding : utf-8 -*-
require "spec_helper"

describe Billet do

  let(:order) { FactoryGirl.create(:order) }
  subject { FactoryGirl.create(:billet, :order => order) }

  it "should return to_s version" do
    subject.to_s.should == "BoletoBancario"
  end

  it "should return human to_s human version" do
    subject.human_to_s.should == "Boleto Bancário"
  end

  context "#schedule_cancellation" do
    it "schedules cancellation in the beginning of 5th business day from creation" do
      Timecop.freeze do
        Resque.should_receive(:enqueue_at).at_least(1).times.with(5.business_days.from_now.beginning_of_day, Abacos::CancelOrder, order.number)
        subject.schedule_cancellation
      end
    end
  end

  context "expiration date" do
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
      BilletExpirationDate.stub!(:expiration_for_two_business_day).and_return(Time.zone.local(2012, 2, 17))
      expect(I18n.l(subject.payment_expiration_date, format: '%Y-%m-%d')).to eq '2012-02-17'
    end
  end

  context "attributes validation" do
    subject { Billet.new }
    it{ should validate_presence_of :receipt }
  end

  describe "#expired_and_waiting_payment?" do
    before do
      @boleto = described_class.new
    end
    context "when is expired and waiting payment" do
      before do
        @boleto.stub(:expired?).and_return(true)
        @boleto.stub_chain("order.waiting_payment?").and_return(true)
      end

      subject { @boleto.expired_and_waiting_payment? }

      it { should be_true }

    end

    context "when is expired but is not waiting payment" do
      before do
        @boleto.stub(:expired?).and_return(true)
        @boleto.stub_chain("order.waiting_payment?").and_return(false)
      end

      subject { @boleto.expired_and_waiting_payment? }

      it { should be_false }
    end

    context "when is not expired but is waiting payment" do
      before do
        @boleto.stub(:expired?).and_return(false)
        @boleto.stub_chain("order.waiting_payment?").and_return(true)
      end

      subject { @boleto.expired_and_waiting_payment? }

      it { should be_false }
    end

    context "when is not expired and is not waiting payment" do
      before do
        @boleto.stub(:expired?).and_return(false)
        @boleto.stub_chain("order.waiting_payment?").and_return(false)
      end

      subject { @boleto.expired_and_waiting_payment? }

      it { should be_false }
    end
  end

  describe ".to_expire" do

    context "billet expired and waiting payment" do
      subject { described_class.to_expire }

      it "should include billet" do
        # FIX this feature/test. It Fails when executed near midnight.
        Timecop.freeze('12:00')  do
          billet = FactoryGirl.create(:billet, :waiting_payment, :to_expire)
          expect(subject).to include billet
        end
      end
    end

    context "billet expired and started" do
      subject { described_class.to_expire }

      it "should include billet" do
        # FIX this feature/test. It Fails when executed near midnight.
        Timecop.freeze('12:00')
        billet = FactoryGirl.create(:billet, :to_expire, state: "started")
        expect(subject).to include billet
      end
    end

    context "billet with old date but with another state" do
      let(:billet) { FactoryGirl.create(:billet, created_at: 5.business_days.ago) }

      subject { described_class.to_expire }

      it { should_not include billet }
    end

    context "billet waiting payment but not old" do
      let(:billet) { FactoryGirl.create(:billet, :waiting_payment) }

      subject { described_class.to_expire }

      it { should_not include billet }
    end

  end
end
