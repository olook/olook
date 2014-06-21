# -*- encoding : utf-8 -*-
class ShareProductMailer < ActionMailer::Base
  helper_method :indefinite_article_for
  default_url_options[:host] = "www.olook.com.br"
  default :from => "avisos@olook.com.br"

  MALE_CATEGORY = [1,3]

  def send_share_message_for(product, informations, email_receiver)
    @user_name = informations[:name_from]
    @user_email = informations[:email_from]
    @email_body = informations[:email_body]
    @product = Product.find(product)

    mail(to: email_receiver, reply_to: @user_email, subject: "#{@user_name.capitalize} viu #{indefinite_article_for(@product.category)} #{@product.category_humanize.downcase} na Olook e quer compartilhar com você. Dá uma olhada!").deliver
  end

  private

  def indefinite_article_for category
    MALE_CATEGORY.include?(category) ? "um" : "uma"
  end
end
