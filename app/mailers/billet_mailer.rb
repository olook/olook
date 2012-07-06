# encoding: utf-8
class BilletMailer < ActionMailer::Base
  default_url_options[:host] = "www.olook.com.br"
  default :from => "olook <avisos@olook.com.br>"

  def self.smtp_settings
    {
      :user_name => "AKIAJJO4CTAEHYW34HGQ",
      :password => "AkYlOmgbIpISW33XVzQq8d9J4GnAgtQlEJuwgIxOFXmU",
      :address => "email-smtp.us-east-1.amazonaws.com",
      :port => 587,
      :authentication => :plain,
      :enable_starttls_auto => true
    }
  end

  def send_reminder_mail(billet)
    @billet = billet
    @user = billet.order.user
    @payday_name = billet.payment_expiration_date.monday? ? "Segunda-feira" : "Amanhã"
    mail(:to => @user.email , :subject => 'Lembramos que seu boleto está pronto para pagamento.')
  end
end
