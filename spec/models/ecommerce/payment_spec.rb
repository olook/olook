require "spec_helper"

describe Payment do
  it { should belong_to(:order) }

  context "creating a Payment" do
    it "should generate a identification code" do
      payment = FactoryGirl.create(:payment)
      payment.identification_code.should_not be_nil
    end
  end
  
  # let(:completed) { "4" }
  # let(:under_review) { "6" }
  # let(:authorized) { "1" }
  # let(:started) { "2" }
  # let(:cancelled) { "5" }
  # let(:waiting_payment) { "3" }
  # let(:reversed) { "7" }
  # let(:refunded) { "9" }
  
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
  
  context "status" do
    it "should return nil with a invalid status" do
      invalid_status = '0'
      subject.set_state(invalid_status).should be(nil)
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
          subject.should_receive(:cancel_order?).twice.and_return(true)
          subject.cancel!
          subject.cancelled?.should eq(true)
        end

        it "should raise error when not cancel_order" do
          subject.should_receive(:cancel_order?).and_raise
          expect {
            subject.cancel!
          }.to raise_error
        end
      end
      
      context "when from waiting_payment" do
        it "should go to canceled when cancel_order" do
          waiting_payment.should_receive(:cancel_order?).and_return(true)
          waiting_payment.cancel!
          waiting_payment.cancelled?.should eq(true)
        end

        it "should raise error when not cancel_order" do
          waiting_payment.should_receive(:cancel_order?).and_raise
          expect {
            waiting_payment.cancel!
          }.to raise_error
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
end
