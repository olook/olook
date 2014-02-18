# -*- encoding : utf-8 -*-
class Admin::PictureProcessMailer < ActionMailer::Base
  default_url_options[:host] = "www.olook.com.br"
  default :from => "olook notification <dev.notifications@olook.com.br>"

  def notify_picture_process( user_email, process_info )
    @user_email = user_email
    @process_info = process_info
    @key = process_info.delete('key') rescue 'erro! sem diretório'
    mail(to: "#{user_email}", bcc: Setting.dev_notification_emails, :subject => "Processamento de Fotos - #{@key} - Terminou! #{Time.zone.now.strftime('%d/%m/%Y')}")
  end
end
