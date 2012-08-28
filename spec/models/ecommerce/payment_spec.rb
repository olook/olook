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
          subject.should_receive(:cancel_order?).and_return(true)
          subject.cancel!
          subject.cancelled?.should eq(true)
        end

        it "should raise error when not cancel_order" do
          subject.should_receive(:cancel_order?).and_return(false)
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
          waiting_payment.should_receive(:cancel_order?).and_return(false)
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

        it "should raise error when not authorize_order" do
          waiting_payment.should_receive(:authorize_order?).and_return(false)
          expect {
            waiting_payment.authorize!
          }.to raise_error
        end
      end
      
      context "when from under_review" do
        it "should go to authorized when authorize_order" do
          under_review.should_receive(:authorize_order?).and_return(true)
          under_review.authorize!
          under_review.authorized?.should eq(true)
        end

        it "should raise error when not authorize_order" do
          under_review.should_receive(:authorize_order?).and_return(false)
          expect {
            under_review.authorize!
          }.to raise_error
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
          under_review.should_receive(:authorize_order?).and_return(true)
          under_review.complete!
          under_review.completed?.should eq(true)
        end

        it "should raise error when not authorize_order" do
          under_review.should_receive(:authorize_order?).and_return(false)
          expect {
            under_review.complete!
          }.to raise_error
        end
      end
    end
    
    
  end
end
