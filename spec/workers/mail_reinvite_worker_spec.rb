# -*- encoding : utf-8 -*-
require "spec_helper"

describe MailReinviteWorker do
  let(:invite) { FactoryGirl.create(:invite) }
  let(:mock_mail) { double :mail }

  it "should send the reinvite e-mail given an invite id" do
    mock_mail.should_receive(:deliver)
    InviteMailer.should_receive(:reinvite_email).with(invite).and_return(mock_mail)

    invite.resubmitted.should be_nil

    described_class.perform(invite.id)

    invite.reload
    invite.resubmitted.should_not be_nil
  end

  it 'should raise "Invite X was already resubmitted" when sending more than two invites' do
    Invite.stub(:find).with(123).and_return( mock_model(Invite, :id => 123, :resubmitted => true) )
    described_class.should_not_receive(:reinvite)
    described_class.perform(123)
  end
end

