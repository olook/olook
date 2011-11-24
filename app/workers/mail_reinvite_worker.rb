# -*- encoding : utf-8 -*-
class MailReinviteWorker
  @queue = :mail_reinvite

  def self.perform(invite_id)
    invite = Invite.find(invite_id)
    raise "The invite ID #{invite_id} was already resubmitted" if invite.resubmitted
    reinvite(invite)
  end

  private
  
  def self.reinvite(invite)
    InviteMailer.reinvite_email(invite).deliver
    invite.resubmitted = true
    invite.save
  end
end

