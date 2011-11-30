# -*- encoding : utf-8 -*-
class InviteMailer < ActionMailer::Base
  default_url_options[:host] = "www.olook.com.br"
  default :from => "olook <vip@o.conviteolook.com.br>"
  
  def self.smtp_settings
    {
      :user_name => "olook",
      :password => "olook123abc",
      :domain => "my.olookmail.com.br",
      :address => "smtp.sendgrid.net",
      :port => 587,
      :authentication => :plain,
      tls: true,
      enable_starttls_auto: true
    }
  end
 
  def invite_email(invite)
    @invite = invite
    mail(:to => @invite.email, :subject => "#{@invite.member_name} te convidou para a olook!")
  end

  def reinvite_email(invite)
    @invite = invite
    mail(:from => "olook <vip@re.conviteolook.com.br>", :to => @invite.email, :subject => "Você recebeu um convite de #{@invite.member_name} mas ainda não se cadastrou.")
  end
end
