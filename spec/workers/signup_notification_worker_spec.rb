# -*- encoding : utf-8 -*-
require 'spec_helper'

describe SignupNotificationWorker do
  it "should send a notification mailer when performs" do
    user_id = 1
    NotificationsMailer.should_receive(:new).and_return(mailer = double)
    mailer.should_receive(:signup).with(user_id)
    SignupNotificationWorker.perform(user_id)
  end
end
