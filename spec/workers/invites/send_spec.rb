# -*- encoding : utf-8 -*-
require 'spec_helper'

describe Invites::Send do
  it "should be set to send_invites queue" do
    described_class.instance_variable_get(:'@queue').should == :send_invites
  end
  
  context "with few invites" do
    let(:member) { FactoryGirl.create(:member) }
    let!(:unsent_invite) { FactoryGirl.create(:invite, :user => member) }
    let!(:sent_invite) { FactoryGirl.create(:sent_invite) }

    it "should be set to send_invites queue" do
      Resque.should_receive(:enqueue).with(Invites::ExpressDelivery, [unsent_invite.id])
      Resque.should_not_receive(:enqueue).with(Invites::BatchDelivery, [])
      described_class.perform
    end
  end

  context "with lots of invites" do
    let(:member_lots_of_invites) { FactoryGirl.create(:member) }
    let!(:lots_of_invites) do
      (1..21).map do
        FactoryGirl.create(:invite, :user => member_lots_of_invites).id
      end
    end

    it "should be set to send_invites queue" do
      Resque.should_not_receive(:enqueue).with(Invites::ExpressDelivery, [])
      Resque.should_receive(:enqueue).with(Invites::BatchDelivery, lots_of_invites)
      described_class.perform
    end
  end
end
