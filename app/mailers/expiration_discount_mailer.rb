# encoding: utf-8
class ExpirationDiscountMailer < ActionMailer::Base
  default_url_options[:host] = "www.olook.com.br"
  default from: "olook <avisos@olook.com.br>"

  def self.smtp_settings
    {
      user_name: "AKIAJJO4CTAEHYW34HGQ",
      password: "AkYlOmgbIpISW33XVzQq8d9J4GnAgtQlEJuwgIxOFXmU",
      address: "email-smtp.us-east-1.amazonaws.com",
      port: 587,
      authentication: :plain,
      enable_starttls_auto: true
    }
  end

   def send_expiration_email(email)
      mail(to: email, subject: "Seus créditos irão expirar em 48 horas")
   end
end
