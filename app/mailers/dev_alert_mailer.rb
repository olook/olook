# -*- encoding : utf-8 -*-
class DevAlertMailer < ActionMailer::Base
  default_url_options[:host] = "www.olook.com.br"

  default :from => "olook notification <dev.notifications@olook.com.br>"

  def order_warns(warn_payments, warn_order)
    @warn_payments = warn_payments
    @warn_orders = warn_order
    mail(:to => "tech@olook.com.br,cristina.logiodice@olook.com.br,diogo.silva@olook.com.br", :subject => "Pedidos que deveriam ter sido capturados pela braspag")
  end

  def product_visibility_notification(products, admin)
    @admin = admin
    @products = products
    mail(:to => %[rafael.manoel@olook.com.br, nelson.haraguchi@olook.com.br, suzane.dirami@olook.com.br, caroline.passos@olook.com.br, katarine.brandao@olook.com.br, cristina.logiodice@olook.com.br], :subject => "Produtos com visibilidade alterada")
  end

  def notify_about_cancelled_billets
    mail(:to => "tech@olook.com.br", :subject => "Cancelamento de boletos rodado com sucesso!")
  end

  def notify_about_products_search_worker
    mail(to: "rafael.manoel@olook.com.br", subject: "ProductSearchWorker executado com sucesso!")
  end

  def notify_about_products_index
    mail(to: %[rafael.manoel@olook.com.br, nelson.haraguchi@olook.com.br, tiago.almeida@olook.com.br], subject: "IndexProductsWorker executado com sucesso!")
  end

  def notify(opts={})
    mail(opts)
  end
end
