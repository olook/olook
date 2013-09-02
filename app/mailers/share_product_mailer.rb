# -*- encoding : utf-8 -*-
class ShareProductMailer < ActionMailer::Base
  default_url_options[:host] = "www.olook.com.br"
  default :from => "avisos@olook.com.br"

  def send_share_message_for(product, informations, email_receiver)
    @user_name = informations[:name_from]
    @user_email = informations[:email_from]
    @product = Product.find(product)
    mail(to: email_receiver, reply_to: @user_email, subject: "#{ @user_name.upcase } viu #{ @product.category_humanize.last } #{ @product.category_humanize } #{ @product.name } no site da olook e lembrou de você").deliver
  end
end
