# -*- encoding : utf-8 -*-
class MailInviteWorker
  @queue = :mail_invite

  def self.perform(invite_id)
    invite = Invite.find(invite_id)

    attributes = configuration
    attributes[:emails] = invite.email

    invite_email = Mailee::Message.create(attributes)
    invite_email.ready unless Rails.env == "test"
  end
  
  def self.configuration
    MAILEE_CONFIG[:invite]
  end
end
