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
    @user = User.find_by_email(email)
    @product = @user ? @user.main_profile_showroom.first : Product.where(is_visible: true, collection_id: Collection.active.id).first
    @expiration_date = (Date.today + 2.days).strftime("%d/%m/%Y")

    mail(to: email, subject: "Seu desconto irá expirar em 48 horas")
  end
end
