# -*- encoding : utf-8 -*-
require 'spec_helper'

describe InviteObserver do
  it "should enqueue the invite to be sent when it's created" do
    Resque.should_receive(:enqueue).with(MailInviteWorker, 8765)
    FactoryGirl.create(:invite, id: 8765)
  end

  it "should not enqueue the invite to be sent if it's created with the sent_at field filled" do
    Resque.should_not_receive(:enqueue).with(MailInviteWorker, 8765)
    FactoryGirl.create(:invite, id: 8765, sent_at: Time.now)
  end
end
