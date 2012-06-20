# -*- encoding : utf-8 -*-
class MemberMailer < ActionMailer::Base
  default :from => "olook <avisos@my.olookmail.com>"

  def self.smtp_settings
    {
      :user_name => "olook2",
      :password => "olook123abc",
      :domain => "my.olookmail.com",
      :address => "smtp.sendgrid.net",
      :port => 587,
      :authentication => :plain,
      :enable_starttls_auto => true

    }
  end

  def welcome_email(member)
    @member = member
    mail(:to => member.email,
         :from => "olook <bemvinda@olook1.com.br>",
         :subject => "#{member.name}, use agora mesmo seus 30% de desconto!"
    )
    headers["X-SMTPAPI"] = { 'category' => 'welcome_email' }.to_json
  end
end
