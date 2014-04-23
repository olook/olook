# -*- encoding : utf-8 -*-
class MailProductPurchasedByInviteeWorker
  @queue = 'low'

  def self.perform(invitee_id)
    invitee = User.find(invitee_id)
    
    mail = MGMMailer.send_first_purchase_by_invitee_notification(invitee)
    mail.deliver    
  end
end
