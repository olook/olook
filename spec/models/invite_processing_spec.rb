# -*- encoding : utf-8 -*-
require 'spec_helper'

describe InvitesProcessing do
  let(:yesterday) { Date.today -1.day }
  let(:last_week) { Date.today - 8.day }

  let!(:sent_invite) { FactoryGirl.create :sent_invite }
  let!(:sent_yesterday) { FactoryGirl.create(:invite, :sent_at => yesterday) }
  let!(:sent_last_week) { FactoryGirl.create(:invite, :sent_at => last_week) }
  let!(:accepted_invite) { FactoryGirl.create(:invite, :accepted_at => Date.today) }


  describe "#invites" do
    it "includes an email invite already sent" do
      subject.invites.should include sent_invite
    end

    it "does not include an invite sent yesterday" do
      subject.invites.should_not include sent_yesterday
    end

    it "includes an invite that was sent more than one week ago" do
      subject.invites.should include sent_last_week
    end

    it "does not include an invite already accepted" do
      subject.invites.should_not include accepted_invite
    end
  end

  describe "#resend_invite" do
    it "enqueues received invite id in MailReinviteWorker" do
      invite_id = 1234
      Resque.should_receive(:enqueue).with(MailReinviteWorker, invite_id)

      subject.resend_invite(invite_id)
    end
  end

  describe "#catalog" do
    it "resends all invites" do
      total_invites = subject.invites.count
      subject.should_receive(:resend_invite).exactly(total_invites).times

      subject.catalog
    end
  end

end
