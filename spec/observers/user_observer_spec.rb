# -*- encoding : utf-8 -*-
require 'spec_helper'

describe UserObserver do
  it "should create a signup event when the user is created" do
    user = FactoryGirl.create(:member)
    user.events.where(:event_type => EventType::SIGNUP).any?.should be_true
  end
  it "enqueues a ShowRoomReadyNotificationWorker email in to be sent in one hour" do
    Resque.should_receive(:enqueue_in).with(1.hour, ShowroomReadyNotificationWorker, anything)
    FactoryGirl.create(:member)
  end
end
