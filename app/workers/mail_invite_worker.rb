# -*- encoding : utf-8 -*-
class MailInviteWorker
  @queue = :mail_invite

  def self.perform(invite_id)
    invite = Invite.find(invite_id)

    raise "The invite ID #{invite_id} was already sent" unless invite.sent_at.nil?
    
    mail = InviteMailer.invite_email(invite)
    mail.deliver
    
    invite.sent_at = Time.now
    invite.save
  end
end
