# -*- encoding : utf-8 -*-
class ContactMailer < ActionMailer::Base
  default :from => "Contato Site <contatosite@olook.com.br>"

  def send_contact_message(user_email, contact_type_id, user_message)
    @contact_type = ContactInformation.find(contact_type_id)
    @user_email, @message = user_email, user_message
    mail(:to => @contact_type.email, :reply_to => @user_email, :subject => "#{@contact_type.title} - #{@user_email}")
  end
end

