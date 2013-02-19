# -*- encoding : utf-8 -*-
class ShareProductMailer < ActionMailer::Base

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

  def send_share_message(user, receiver, product)
    mail(:to => @receiver, :reply_to => @user.email, :subject => "#{@product.id}")
  end
end

