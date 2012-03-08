# -*- encoding : utf-8 -*-
require 'spec_helper'

describe UserObserver do

  it "should create a signup event when the user is created" do
    user = FactoryGirl.create(:member)
    user.events.where(:event_type => EventType::SIGNUP).any?.should be_true
  end

  it "enqueues a SignupNotificationWorker in resque" do
    Resque.should_receive(:enqueue).with(SignupNotificationWorker, anything)
    FactoryGirl.create(:member)
  end

  it "enqueues a ShowroomReadyNotificationWorker in Resque after 1 day" do
    Resque.should_receive(:enqueue_in).with(1.day, ShowroomReadyNotificationWorker, anything)
    FactoryGirl.create(:member)
  end

  it "calls the credit method for adding the invite bonus" do
    Credit.should_receive(:add_invite_bonus_for_invitee)
    FactoryGirl.create(:member)
  end

end
