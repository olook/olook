# -*- encoding : utf-8 -*-
class ShareProductMailer < ActionMailer::Base
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

  def send_share_message_for(product, informations)
    user_email = informations[:email_from]
    email_receiver = informations[:emails_to_deliver]
    mail(to: email_receiver, reply_to: user_email, subject: "#{product.id}").deliver
  end
end
