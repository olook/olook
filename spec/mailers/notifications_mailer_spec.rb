# -*- encoding : utf-8 -*-
require "spec_helper"

describe NotificationsMailer do
  let(:mailer) { NotificationsMailer.new }

  it "should send signup notification" do
    user = double
    user.stub(:email)
    Mailee::Message.should_receive(:create)
    mailer.signup(user)
  end
end
