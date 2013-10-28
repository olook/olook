require "spec_helper"

describe Payment do
  it { should belong_to(:order) }

  context "creating a Payment" do
    it "should generate a identification code" do
      payment = FactoryGirl.create(:payment)
      payment.identification_code.should_not be_nil
    end

  end

  describe "callbacks" do

    describe "#set_payment_expiration_date" do
      context "when payment is a Billet" do
        context "and has no payment_expiration_date" do
          subject { FactoryGirl.create(:billet, :with_order) }

          it "sets an expiration date" do
            Timecop.freeze do
              expect(subject.payment_expiration_date).to eq(subject.send(:build_payment_expiration_date))
            end
          end
        end

        context "when billet has payment_expiration_date already" do
          let(:expiration_date) { Time.zone.now - 1.day }
          subject { FactoryGirl.create(:billet, :with_order, payment_expiration_date: expiration_date) }

          context "keeps the expiration date" do
            it { expect(subject.payment_expiration_date).to eq(expiration_date) }
          end
        end
      end

      context "when payment is a Credit Card" do
        context "and has no payment_expiration_date" do
          subject { FactoryGirl.create(:credit_card) }

          it "sets an expiration date" do
            Timecop.freeze do
              expect(subject.payment_expiration_date).to eq(subject.build_payment_expiration_date)
            end
          end
        end

        context "when billet has payment_expiration_date already" do
          let(:expiration_date) { Time.zone.now - 1.day }
          subject { FactoryGirl.create(:credit_card, payment_expiration_date: expiration_date) }

          context "keeps the expiration date" do
            it { expect(subject.payment_expiration_date).to eq(expiration_date) }
          end
        end
      end

      context "when payment is Debit" do
        context "and has no payment_expiration_date" do
          subject { FactoryGirl.create(:debit) }

          it "sets an expiration date" do
            Timecop.freeze do
              expect(subject.payment_expiration_date).to eq(subject.build_payment_expiration_date)
            end
          end
        end

        context "when billet has payment_expiration_date already" do
          let(:expiration_date) { Time.zone.now - 1.day }
          subject { FactoryGirl.create(:debit, payment_expiration_date: expiration_date) }

          context "keeps the expiration date" do
            it { expect(subject.payment_expiration_date).to eq(expiration_date) }
          end
        end
      end

    end
  end

  let(:waiting_payment) do
    result = subject()
    result.stub(:deliver_payment?).and_return(true)
    result.start!
    result.deliver!
    result
  end

  let(:authorized) do
    result = subject()
    result.stub(:deliver_payment?).and_return(true)
    result.stub(:authorize_order?).and_return(true)
    result.start!
    result.deliver!
    result.authorize!
    result
  end

  let(:completed) do
    result = subject()
    result.stub(:deliver_payment?).and_return(true)
    result.stub(:authorize_order?).and_return(true)
    result.start!
    result.deliver!
    result.authorize!
    result.complete!
    result
  end

  let(:under_review) do
    result = subject()
    result.stub(:deliver_payment?).and_return(true)
    result.stub(:review_order?).and_return(true)
    result.start!
    result.deliver!
    result.review!
    result
  end

  context "authorize_order?" do
    it "should return false if order is nil" do
      payment = FactoryGirl.create(:payment)
      payment.order = nil
      payment.authorize_order?.should eq(false)
    end
  end

  describe "state machine" do
    it "should start the order" do
      subject.start
      subject.started?.should eq(true)
    end

    context "try to deliver" do
      it "should go to waiting_payment when delivered" do
        subject.should_receive(:deliver_payment?).and_return(true)
        subject.deliver
        subject.waiting_payment?.should eq(true)
      end

      it "should raise error when not delivered" do
        subject.should_receive(:deliver_payment?).and_return(false)
        expect {
          subject.deliver!
        }.to raise_error
      end
    end

    context "try to cancel" do
      context "when from started" do
        it "should go to canceled when cancel_order" do
          # subject.should_receive(:cancel_order?).twice.and_return(true)
          subject.cancel!
          subject.cancelled?.should eq(true)
        end

      end

      context "when from waiting_payment" do
        it "should go to canceled when cancel_order" do
          # waiting_payment.should_receive(:cancel_order?).and_return(true)
          waiting_payment.cancel!
          waiting_payment.cancelled?.should eq(true)
        end
      end
    end

    context "try to authorize" do
      context "when from waiting_payment" do
        it "should go to authorized when authorize_order" do
          waiting_payment.should_receive(:authorize_order?).and_return(true)
          waiting_payment.authorize!
          waiting_payment.authorized?.should eq(true)
        end
      end

      context "when from under_review" do
        it "should go to authorized when authorize_order" do
          under_review.should_receive(:authorize_order?).and_return(true)
          under_review.authorize!
          under_review.authorized?.should eq(true)
        end
      end
    end

    context "try to complete" do
      context "when from authorized" do
        it "should go to completed" do
          authorized.complete!
          authorized.completed?.should eq(true)
        end
      end

      context "when from under_review" do
        it "should go to completed when authorize_order" do
          under_review.complete!
          under_review.completed?.should eq(true)
        end
      end
    end

    context "try to review" do
      context "when from waiting_payment" do
        it "should go to under_review when review_order" do
          waiting_payment.should_receive(:review_order?).and_return(true)
          waiting_payment.review!
          waiting_payment.under_review?.should eq(true)
        end

        it "should raise error when not review_order" do
          waiting_payment.should_receive(:review_order?).and_raise
          expect {
            waiting_payment.review!
          }.to raise_error
        end
      end

      context "when from authorized" do
        it "should go to under_review when review_order" do
          authorized.should_receive(:review_order?).and_return(true)
          authorized.review!
          authorized.under_review?.should eq(true)
        end

        it "should raise error when not review_order" do
          authorized.should_receive(:review_order?).and_return(false)
          expect {
            authorized.review!
          }.to raise_error
        end
      end
    end

    context "try to reverse" do
      context "when from completed" do
        it "should go to reversed when reverse_order" do
          completed.should_receive(:reverse_order?).and_return(true)
          completed.reverse!
          completed.reversed?.should eq(true)
        end

        it "should raise error when not reverse_order" do
          completed.should_receive(:reverse_order?).and_raise
          expect {
            completed.reverse!
          }.to raise_error
        end
      end

      context "when from authorized" do
        it "should go to reversed when reverse_order" do
          authorized.should_receive(:reverse_order?).and_return(true)
          authorized.reverse!
          authorized.reversed?.should eq(true)
        end

        it "should raise error when not reverse_order" do
          authorized.should_receive(:reverse_order?).and_raise
          expect {
            authorized.reverse!
          }.to raise_error
        end
      end

      context "when from under_review" do
        it "should go to reversed when reverse_order" do
          under_review.should_receive(:reverse_order?).and_return(true)
          under_review.reverse!
          under_review.reversed?.should eq(true)
        end

        it "should raise error when not reverse_order" do
          under_review.should_receive(:reverse_order?).and_raise
          expect {
            under_review.reverse!
          }.to raise_error
        end
      end
    end

    context "try to refund" do
      context "when from completed" do
        it "should go to refunded when refund_order" do
          completed.should_receive(:refund_order?).and_return(true)
          completed.refund!
          completed.refunded?.should eq(true)
        end

        it "should raise error when not refund_order" do
          completed.should_receive(:refund_order?).and_raise
          expect {
            completed.refund!
          }.to raise_error
        end
      end

      context "when from authorized" do
        it "should go to refunded when refund_order" do
          authorized.should_receive(:refund_order?).and_return(true)
          authorized.refund!
          authorized.refunded?.should eq(true)
        end

        it "should raise error when not refund_order" do
          authorized.should_receive(:refund_order?).and_raise
          expect {
            authorized.refund!
          }.to raise_error
        end
      end

      context "when from under_review" do
        it "should go to refunded when refund_order" do
          under_review.should_receive(:refund_order?).and_return(true)
          under_review.refund!
          under_review.refunded?.should eq(true)
        end

        it "should raise error when not refund_order" do
          under_review.should_receive(:refund_order?).and_raise
          expect {
            under_review.refund!
          }.to raise_error
        end
      end

    end
  end

  describe '#authorize_and_notify_if_is_a_billet' do
    let(:order) { FactoryGirl.build(:order) }
    let(:mock_mail) { double :mail }

    before do
      subject.stub(:order).and_return(order)
      order.stub(:number).and_return(123)
    end
    context "when payment is not a billet" do
      subject { FactoryGirl.create(:credit_card) }

      it "sends an email to notify about authorization" do
        DevAlertMailer.should_not_receive(:notify).with(to: 'rafael.manoel@olook.com.br', subject: "Ordem de numero #{ subject.order.number } foi autorizada")
        mock_mail.should_not_receive(:deliver)
        subject.authorize_and_notify_if_is_a_billet
      end

      it "doesn't authorize" do
        subject.should_not_receive(:authorize)
        subject.authorize_and_notify_if_is_a_billet
      end

    end

    context "when is a billet" do
      subject { FactoryGirl.create(:billet, :waiting_payment) }

      it "authorizes" do
        subject.should_receive(:authorize)
        subject.authorize_and_notify_if_is_a_billet
      end

      it "sends an email to notify about authorization" do
        DevAlertMailer.should_receive(:notify).with(to: 'rafael.manoel@olook.com.br', subject: "Ordem de numero #{ subject.order.number } foi autorizada").and_return(mock_mail)
        mock_mail.should_receive(:deliver)
        subject.authorize_and_notify_if_is_a_billet
      end

    end

  end
end
