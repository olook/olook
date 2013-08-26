# -*- encoding : utf-8 -*-
class IntegrationProductsAlert < ActionMailer::Base
  default_url_options[:host] = "www.olook.com.br"

  default :from => "olook notification <dev.notifications@olook.com.br>"

  def notify(user, products_amount, errors)
    user = user
    @products_amount = products_amount
    @errors = errors
    email = mail(:to => "#{ user }, rafael.manoel@olook.com.br", :subject => "Sincronização de produtos concluída")
    email.deliver
  end

end
