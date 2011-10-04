# -*- encoding : utf-8 -*-
require "spec_helper"

describe InvitesMailer do
  it "should send the invite e-mail given a member" do
    invite = FactoryGirl.create(:invite)
    sent_email = InvitesMailer.invite_email(invite).deliver
    ActionMailer::Base.deliveries.should_not be_empty

    sent_email.to.should include(invite.email)
    sent_email.subject.should == "#{invite.user.name} a convidou para o olook!"
  end
end
