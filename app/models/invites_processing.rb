# -*- encoding : utf-8 -*-
class InvitesProcessing
  def catalog
    invites.each { |invite| resend_invite(invite.id) }
  end

  def resend_invite(invite_id)
    Resque.enqueue(MailReinviteWorker, invite_id)
  end

  def invites
    Invite.where("accepted_at is ? AND sent_at < ? AND resubmitted is ?", nil, 7.days.ago, nil)
  end
end

