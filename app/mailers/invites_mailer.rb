# -*- encoding : utf-8 -*-
class InvitesMailer < ActionMailer::Base
  include Resque::Mailer

  default from: "do-not-reply@"
  default_url_options[:host] = "olook.com"

  def invite_email(invite_id)
    @invite = Invite.find(invite_id)
    mail :to => @invite.email, :subject => "#{@invite.user.name} a convidou para o olook!"
  end
end
