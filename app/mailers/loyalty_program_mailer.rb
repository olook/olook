# -*- encoding : utf-8 -*-
class LoyaltyProgramMailer < ActionMailer::Base
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

  def send_enabled_credits_notification user
    @user = user
    #TODO: calcular créditos disponíveis
    mail(:to => @user.email, :subject => "#{user.first_name}, você tem R$ #{('%.2f' % user.user_credits_for(:loyalty_program).total).gsub('.',',')} em créditos disponíveis para uso.")
  end

  def send_expiration_warning (user, expires_tomorrow = false)
    @user = user

    user_credit = user.user_credits_for(:loyalty_program)
    @credit_amount = LoyaltyProgramCreditType.credit_amount_to_expire(user_credit)
    @end_of_month = DateTime.now.end_of_month.strftime("%d/%m/%Y")

    subject = expires_tomorrow ? "Corra #{user.first_name}, seus R$ #{('%.2f' % @credit_amount).gsub('.',',')} em créditos expiram amanhã!" : "#{user.first_name}, seus R$ #{('%.2f' % @credit_amount).gsub('.',',')} em créditos vão expirar!"

    @user = user
    #TODO: calcular créditos disponíveis
    mail(:to => @user.email, :subject => subject)
  end  

end
