# -*- encoding : utf-8 -*-
require 'spec_helper'

describe Invite do

  subject { FactoryGirl.create(:invite) }
  let(:user) {FactoryGirl.create(:user)}

  describe "email uniqueness scope" do
    it "should build and save a invite" do
      invite = user.invites.build(:email => "email@mail.com")
      expect{
        invite.save
      }.to change(Invite, :count).by(1)
    end

    it "should not save a invite if the email already exists for the user context" do
      user.invites.create(:email => "email@mail.com")
      invite = user.invites.build(:email => "email@mail.com")
      expect{
        invite.save
      }.to change(Invite, :count).by(0)
    end
  end

  describe "unsent scope" do
    it "should contain only unsent invites" do
      described_class.unsent.should == [subject]
    end

    it "should not contain sent invites" do
      subject.sent_at = Time.now
      subject.save
      described_class.unsent.should be_empty
    end
  end

  describe "sent scope" do
    it "should not contain unsent invites" do
      described_class.sent.should be_empty
    end

    it "should only contain sent invites" do
      subject.sent_at = Time.now
      subject.save
      described_class.sent.should == [subject]
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

  let(:invitee) { FactoryGirl.create(:member, :first_name => 'Accepting') }

  describe "invite status" do
    context "when the user accept the invite" do
      it "should return yes" do
        user = subject.user
        subject.accept_invitation(invitee)
        described_class.status_for_user_invite(user.id, subject).should eq(Invite::STATUS[:yes])
      end
    end

    context "when the user didnt accept the invite" do
      it "should return no" do
        user = subject.user
        described_class.status_for_user_invite(user.id, subject).should eq(Invite::STATUS[:no])
      end
    end

    context "when the user already accepted the invite from another user" do
      it "should return accepted" do
        invite = FactoryGirl.create(:invite, :email => subject.email)
        another_invitee = FactoryGirl.create(:user)
        invite.accept_invitation(another_invitee)
        subject.accept_invitation(invitee)
        described_class.status_for_user_invite(subject.user.id, subject).should eq(Invite::STATUS[:accepted])
      end
    end
  end

  describe "#accept_invitation" do
    let(:accepting_datetime)   { Time.parse('2011-10-14 18:30') }

    it "should store the accepting member" do
      Time.stub(:now).and_return(accepting_datetime)

      subject.accept_invitation(invitee)

      subject.invited_member.should == invitee
      subject.accepted_at.should == accepting_datetime
    end
  end

  describe "accepted scope" do
    it "should not contain unaccepted invites" do
      described_class.accepted.should be_empty
    end

    it "should only contain accepted invites" do
      subject.accept_invitation(invitee)
      described_class.accepted.should == [subject]
    end
  end

  describe ".find_inviter" do
    let!(:invitee) { FactoryGirl.create(:user) }

    context "when the invitee has no inviter" do
      it "returns nil" do
        described_class.find_inviter(invitee).should be_nil
      end
    end

    context "when the invitee has one inviter" do
      before do
        subject.accept_invitation(invitee)
      end

      it "returns its inviter" do
        described_class.find_inviter(invitee).should == subject.user
      end
    end
  end

end
