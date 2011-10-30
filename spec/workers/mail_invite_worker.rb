# -*- encoding : utf-8 -*-
require "spec_helper"

describe MailInviteWorker do
  it "should send the invite e-mail given an invite id" do
    invite = FactoryGirl.create(:invite)
    described_class.stub(:configuration).and_return({mailee: 'config'})
    Mailee::Message.should_receive(:create).with({mailee: 'config', emails: invite.email})
    
    described_class.perform(invite.id)
  end
end
