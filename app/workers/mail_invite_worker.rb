# -*- encoding : utf-8 -*-
class MailInviteWorker
  @queue = :mail_invite

  def self.perform(invite_id)
    invite = Invite.find(invite_id)

    attributes = configuration

    template = Mailee::Template.find(attributes[:template_id])
    html = template.html.gsub /__invite_link__/, accept_invitation_url(invite.member_invite_token)
    html.gsub! /__inviter_name__/, invite.member_name
    attributes.delete(:template_id)
    
    attributes[:subject] = attributes[:subject].gsub /__inviter_name__/, invite.member_name
    attributes[:emails] = invite.email
    attributes[:html] = html

    invite_email = Mailee::Message.create(attributes)
    invite_email.ready unless Rails.env == "test"
  end
  
  def self.accept_invitation_url(token)
    Rails.application.routes.url_helpers.accept_invitation_url token, :host => 'olook.com.br'
  end
  
  def self.configuration
    MAILEE_CONFIG[:invite].clone
  end
end
