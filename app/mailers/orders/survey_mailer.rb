# -*- encoding : utf-8 -*-
class Orders::SurveyMailer < ActionMailer::Base
  default_url_options[:host] = "www.olook.com.br"
  default :from => "Equipe Olook <avisos@olook.com.br>"

  def order_survey order
    @order = order
    @link = Survey::Link.generate @order.line_items
    mail(:to => @order.user_email, :subject => "Pesquisa de satisfação")
  end
end
