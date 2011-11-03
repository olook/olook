# -*- encoding : utf-8 -*-
require 'spec_helper'

describe Invite do

  subject { FactoryGirl.create(:invite) }

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

  let(:accepting_member) { FactoryGirl.create(:member, :first_name => 'Accepting') }

  describe "invite status" do
    context "when the user accept the invite" do
      it "should return yes" do
        user = subject.user
        subject.accept_invitation(accepting_member)
        Invite.status_for_user_invite(user.id, subject).should eq(Invite::STATUS[:yes])
      end
    end

    context "when the user didnt accept the invite" do
      it "should return no" do
        user = subject.user
        Invite.status_for_user_invite(user.id, subject).should eq(Invite::STATUS[:no])
      end
    end

    context "when the user already accepted the invite from another user" do
      it "should return accepted" do
        invite = FactoryGirl.create(:invite, :email => subject.email)
        accepting_user = FactoryGirl.create(:user)
        invite.accept_invitation(accepting_user)
        subject.accept_invitation(accepting_member)
        Invite.status_for_user_invite(subject.user.id, subject).should eq(Invite::STATUS[:accepted])
      end
    end
  end

  describe "#accept_invitation" do
    let(:accepting_datetime)   { Time.parse('2011-10-14 18:30') }

    it "should store the accepting member" do
      Time.stub(:now).and_return(accepting_datetime)

      subject.accept_invitation(accepting_member)

      subject.invited_member.should == accepting_member
      subject.accepted_at.should == accepting_datetime
    end
  end

  describe "accepted scope" do
    it "should not contain unaccepted invites" do
      Invite.accepted.should be_empty
    end

    it "should only contain accepted invites" do
      subject.accept_invitation(accepting_member)
      Invite.accepted.should == [subject]
    end
  end
end
