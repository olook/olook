require 'spec_helper'

describe OrderStateTransition do
  
  let(:order) { FactoryGirl.create(:order) }
  let(:authorized_order) {FactoryGirl.create(:authorized_order)}

  before do
    Resque.stub(:enqueue)
    Resque.stub(:enqueue_in)
  end

  it "should audit the transition" do
    order.authorized
    subject = order.order_state_transitions.last
    subject.event.should == "authorized"
    subject.from.should == "waiting_payment"
    subject.to.should == "authorized"
  end

  it "should save a transaction attributes if a payment exists" do
    authorized_order.picking
    subject = authorized_order.order_state_transitions.last
    subject.to.should == "picking"
    subject.event.should == "picking"
    subject.payment_response.should == "Sucesso"
    subject.payment_transaction_status.should == "EmAnalise"
  end

  it "should have nil transaction attributes with no associated payment" do
    order.waiting_payment
    subject = order.order_state_transitions.last
    subject.to.should == "waiting_payment"
    subject.payment_response.should be_nil
    subject.payment_transaction_status.should be_nil
    subject.gateway_status_reason.should be_nil
  end

end
