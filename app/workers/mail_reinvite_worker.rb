# -*- encoding : utf-8 -*-
class MailReinviteWorker
  @queue = :mail_reinvite

  def self.perform(invite_id)
    invite = Invite.find(invite_id)
    reinvite(invite) unless invite.resubmitted
  end

  private

  def self.reinvite(invite)
    InviteMailer.reinvite_email(invite).deliver
    invite.resubmitted = true
    invite.save
  end
end

