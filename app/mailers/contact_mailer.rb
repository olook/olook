# -*- encoding : utf-8 -*-
class ContactMailer < ActionMailer::Base
  default :from => "Fale com <falecom@olook.com.br>"
  
  def self.smtp_settings
    {
      :user_name => "AKIAJJO4CTAEHYW34HGQ",
      :password => "AkYlOmgbIpISW33XVzQq8d9J4GnAgtQlEJuwgIxOFXmU",
      :address => "email-smtp.us-east-1.amazonaws.com",
      :port => 587,
      :authentication => :plain,
      tls: true,
      enable_starttls_auto: true
    }
  end

  def send_contact_message(user_email, contact_type_id, user_message)
    @contact_type = ContactInformation.find(contact_type_id)
    @user_email, @message = user_email, user_message
    mail(:to => @contact_type.email, :reply_to => @user_email, :subject => "#{@contact_type.title} - #{@user_email}")
  end
end

