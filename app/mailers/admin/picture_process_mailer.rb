# -*- encoding : utf-8 -*-
class Admin::PictureProcessMailer < ActionMailer::Base
  default_url_options[:host] = "www.olook.com.br"
  default :from => "olook notification <dev.notifications@olook.com.br>"

  def notify_picture_process( user_email, process_info )
    @user_email = user_email
    @process_info = process_info
    mail(to: "#{user_email},tiago.almeida@olook.com.br", :subject => "Informações sobre processamento de images")
  end
end
