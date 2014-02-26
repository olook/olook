# -*- encoding : utf-8 -*-
class OrderStatusMailer < ActionMailer::Base
  default_url_options[:host] = "www.olook.com.br"
  default :from => "Equipe Olook <avisos@olook.com.br>"

  def order_survey order
    @order = order
    mail(:to => @order.user_email, :subject => "Pesquisa de satisfação")
  end
end
