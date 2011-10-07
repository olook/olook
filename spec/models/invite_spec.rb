# -*- encoding : utf-8 -*-
require 'spec_helper'

describe Invite do

  subject { FactoryGirl.create(:invite) }

  describe "#send_invitation" do
    it "should send the invitation by e-mail" do
      mock_email = double(:email)
      mock_email.should_receive(:deliver)
      InvitesMailer.should_receive(:invite_email).with(subject.id).and_return(mock_email)
      subject.send_invitation
    end
  end
  
end
