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
  
  describe "unsent scope" do
    it "should contain only unsent invites" do
      Invite.unsent.should == [subject]
    end

    it "should not contain sent invites" do
      subject.sent_at = Time.now
      subject.save
      Invite.unsent.should be_empty
    end
  end

  describe "sent scope" do
    it "should not contain unsent invites" do
      Invite.sent.should be_empty
    end

    it "should only contain sent invites" do
      subject.sent_at = Time.now
      subject.save
      Invite.sent.should == [subject]
    end
  end
  
  describe "getting invinting member data" do
    it "should be able to return the member name" do
      subject.member_name.should == subject.user.name
    end
    it "should be able to return the member invite link" do
      subject.member_invite_token.should == subject.user.invite_token
    end
  end
end
