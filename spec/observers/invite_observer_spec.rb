# -*- encoding : utf-8 -*-
require 'spec_helper'

describe InviteObserver do
  it "should create a signup event when the user is created" do
    Resque.should_receive(:enqueue).with(MailInviteWorker, 8765)
    FactoryGirl.create(:invite, id: 8765)
  end
end
