require 'spec_helper'

describe OrderStateTransition do
  let(:order) { FactoryGirl.create(:order) }

  it "should audit the transition" do
    order.waiting_payment
    order.authorized
    subject = order.order_state_transitions.last
    subject.event.should == "authorized"
    subject.from.should == "waiting_payment"
    subject.to.should == "authorized"
  end
end
