# encoding: utf-8
class SACAlertMailer < ActionMailer::Base
  default_url_options[:host] = "www.olook.com.br"
  default :from => "olook <avisos@olook.com.br>"

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

  def send_billet_alert(alert, subscribers)
    @order = subject_under_analysis(alert)
    mail(:to => subscribers[0], :cc => subscribers[1..subscribers.length-1],  :subject => alert['header'])
  end

  def send_error_alert(alert, subscribers)
    @alert = alert
    subject_under_analysis(alert) unless alert["order_id"].nil?
    mail(:to => subscribers[0] , :cc => subscribers,  :subject => alert['header'])
  end

  def send_fraud_analysis_alert(alert, subscribers)
    @order = subject_under_analysis(alert)
    mail(:to => subscribers[0] , :cc => subscribers,  :subject => alert['header'])
  end

  private

  def subject_under_analysis(alert)
   Order.find_by_id(alert["order_id"])
  end

end
