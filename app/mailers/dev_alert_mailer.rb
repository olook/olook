# -*- encoding : utf-8 -*-
class DevAlertMailer < BaseMailer
  default :from => "olook notification <tiago.almeida@olook.com.br>"

  def braspag_capture_warn(warn_payments, warn_order)
    @warn_payments = warn_payments
    @warn_orders = warn_order
    mail(:to => "incidentes@olook.com.br", :subject => "Pedidos que deveriam ter sido capturados pela braspag")
  end
end
