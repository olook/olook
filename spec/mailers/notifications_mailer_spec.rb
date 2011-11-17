# -*- encoding : utf-8 -*-
require "spec_helper"

describe NotificationsMailer do
  let(:mailer) { NotificationsMailer.new }
  let(:user_id) { 1 }
  let(:member) { stub_model(User, email: 'stubbed email', name: 'stubbed name', welcome_sent_at: nil) }

  context 'for a member who just signed up' do
    it "should send signup notification" do
      member.should_receive(:'welcome_sent_at=')
      User.stub(:find).with(user_id).and_return(member)

      Mailee::Message.should_receive(:create)
      template = double
      template.stub(:html).and_return('')

      Mailee::Template.stub(:find).and_return(template)

      mailer.signup(user_id)
    end
  end

  context 'for a member who already received a welcome message' do
    it "should send signup notification" do
      member.stub(:welcome_sent_at).and_return(Time.now)
      User.stub(:find).with(user_id).and_return(member)
      expect {
        mailer.signup(user_id)
      }.to raise_error(RuntimeError, "The welcome message for member #{user_id} was already sent")
    end
  end
end
