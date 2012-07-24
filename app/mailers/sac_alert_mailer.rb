# -*- encoding : utf-8 -*-
class SACAlertMailer < ActionMailer::Base
  default_url_options[:host] = "www.olook.com.br"
  default :from => "sac notifications <sac.notifications@olook.com.br>"

  def self.smtp_settings
    {
      :user_name => "AKIAJJO4CTAEHYW34HGQ",
      :password => "AkYlOmgbIpISW33XVzQq8d9J4GnAgtQlEJuwgIxOFXmU",
      :address => "email-smtp.us-east-1.amazonaws.com",
      :port => 587,
      :authentication => :plain,
      :enable_starttls_auto => true
    }
  end

  def send_notification(alert)
    @order, @alert = Order.find(alert['order']['id']), alert
    mail(:to => alert['subscribers'].first, :cc => alert['subscribers'] - [alert['subscribers'].first], 
    :subject => alert['subject'], :template_name => "#{alert['type']}_notification")
  end

end
