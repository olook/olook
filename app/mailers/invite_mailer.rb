# -*- encoding : utf-8 -*-
class InviteMailer < ActionMailer::Base
  default_url_options[:host] = "www.olook.com.br"
  default :from => "olook <bemvinda@olook.com.br>"

  def invite_email(invite)
    @invite = invite
    send_invite(@invite)
  end

  def reinvite_email(invite)
    @invite = invite
    send_invite(@invite)
  end

  private

  def send_invite(invite)
    mail(:to => invite.email, :subject => "#{invite.member_name} te convidou para a olook!")
    headers["X-SMTPAPI"] = { 'category' => 'invite_email' }.to_json
  end
end
