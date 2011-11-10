# -*- encoding : utf-8 -*-
require "spec_helper"

describe NotificationsMailer do
  let(:mailer) { NotificationsMailer.new }

  it "should send signup notification" do
    user_id = 1
    user = double
    user.stub(:email).and_return('stubbed email');
    user.stub(:name).and_return('stubbed name');
    User.stub(:find).with(user_id).and_return(user)
    Mailee::Message.should_receive(:create)
    template = double
    template.stub(:html).and_return('')
    Mailee::Template.stub(:find).and_return(template)
    mailer.signup(user_id)
  end
end
