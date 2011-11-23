# -*- encoding : utf-8 -*-
class MemberMailer < ActionMailer::Base
  default :from => "\"Olook\" <bemvinda@my.olookmail.com.br>"
  
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
 
  def welcome_email(member)
    @member = member
    mail( :to => member.email,
          :subject => "#{member.name}, seja bem vinda! Seu cadastro foi feito com sucesso!"
          )
  end
end
