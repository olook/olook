# -*- encoding : utf-8 -*-
class InCartMailer < ActionMailer::Base
  default_url_options[:host] = "www.olook.com.br"
  default :from => "olook <avisos@olook.com.br>"

  def send_in_cart_mail( cart, products )
  	@cart = cart
  	@user = @cart.user
  	@products = products
  	subject = "#{@user.first_name}, os seus produtos ainda estão disponíveis."
    mail(:to => @user.email , :subject => subject)
  end

end