# -*- encoding : utf-8 -*-
class InvitesProcessing
  def catalog
    invites.each { |invite| resend_invite(invite) }
  end

  def resend_invite(invite)
    Resque.enqueue(MailReinviteWorker, invite.id)
  end

  def invites
    Invite.where("accepted_at is ? AND sent_at < ? AND resubmitted is ?", nil, 7.days.ago, nil)
  end
end

