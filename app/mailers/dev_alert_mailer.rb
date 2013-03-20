# -*- encoding : utf-8 -*-
class DevAlertMailer < BaseMailer
  default_url_options[:host] = "www.olook.com.br"
  default :from => "dev notifications <dev@olook.com.br>"

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

  def braspag_capture_warn(warn_payments)
    @warn_payments = warn_payments
    mail(:to => "incidentes@olook.com.br", :subject => "Pedidos que deveriam ter sido capturados pela braspag")
  end
end
