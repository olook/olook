# -*- encoding : utf-8 -*-
class MailRegisteredInviteeWorker
  @queue = :mail_invite

  def self.perform(invitee_id)
    invitee = User.find(invitee_id)
    
    mail = MGMMailer.send_registered_invitee_notification(invitee)
    mail.deliver    
  end
end