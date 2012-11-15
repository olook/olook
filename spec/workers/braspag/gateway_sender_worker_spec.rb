require 'spec_helper'

describe Braspag::GatewaySenderWorker do
  let(:user) { FactoryGirl.create(:user) }
  let(:order) { FactoryGirl.create(:order, :user => user) }
  let(:credit_card) { FactoryGirl.create(:credit_card, :order => order, :user => user, :gateway => Payment::GATEWAYS[:braspag]) }

  context "performing a queue call" do
    subject {Braspag::GatewaySenderWorker.new}

    it "should call the process enqueued request method" do
      Payments::BraspagSenderStrategy.any_instance.should_receive(:process_enqueued_request)
      Braspag::GatewaySenderWorker.perform(credit_card.id)
    end

  end

end
