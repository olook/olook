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

  def billet_notification(order, to)
    @order = order
    mail(:to => to, :subject => "Pedido: #{order.number} | Boleto")
  end
  
  def fraud_analysis_notification(order, to)
    @order = order
    mail(:to => to, :subject => "Análise de Fraude | Pedido : #{order.number}")
  end
end
