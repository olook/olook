# -*- encoding : utf-8 -*-
class ValentineInviteMailer < ActionMailer::Base
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
      :enable_starttls_auto => true
    }
  end

  def invite_email(user_name, to)
    @user_name = user_name
    send_invite(user_name, to)
  end

  private
  def send_invite(user_name, to)
    mail(:to => to, :subject => "#{user_name} te convidou para a olook!")
    headers["X-SMTPAPI"] = { 'category' => 'valentine_invite_email' }.to_json
  end
end
