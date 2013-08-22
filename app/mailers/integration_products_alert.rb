# -*- encoding : utf-8 -*-
class IntegrationProductsAlert < ActionMailer::Base
  default_url_options[:host] = "www.olook.com.br"

  default :from => "olook notification <dev.notifications@olook.com.br>"

  def notify opts

  end

end
