# -*- encoding : utf-8 -*-
class PictureProcessMailer < ActionMailer::Base
  default_url_options[:host] = "www.olook.com.br"
  default :from => "olook notification <dev.notifications@olook.com.br>"

  def notify_picture_process(process_info)
    
  end
end
