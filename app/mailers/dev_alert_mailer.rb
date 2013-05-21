# -*- encoding : utf-8 -*-
class DevAlertMailer < ActionMailer::Base
  default_url_options[:host] = "www.olook.com.br"

  default :from => "olook notification <tiago.almeida@olook.com.br>"

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

  def order_warns(warn_payments, warn_order)
    @warn_payments = warn_payments
    @warn_orders = warn_order
    mail(:to => "tech@olook.com.br", :subject => "Pedidos que deveriam ter sido capturados pela braspag")
  end

  def product_visibility_notification(products, admin)
    @admin = admin
    @products = products
    mail(:to => %[rafael.manoel@olook.com.br, nelson.haraguchi@olook.com.br, andressa.vieira@olook.com.br, luiza.bet@olook.com.br, suzane.dirami@olook.com.br, caroline.passos@olook.com.br, katarine.brandao@olook.com.br], :subject => "Produtos com visibilidade alterada")
  end

  def notify_about_cancelled_billets
    mail(:to => "tech@olook.com.br", :subject => "Cancelamento de boletos rodado com sucesso!")
  end
end
