# -*- encoding : utf-8 -*-
class AdminReportMailer < ActionMailer::Base
  default_url_options[:host] = "www.olook.com.br"

  default :from => "olook notification <dev.notifications@olook.com.br>"

  def send_report(filepath, email)
    @email = email
    attachments["clear_sale_report.csv"] = File.read(filepath)
    mail(to: @email, subject: "Relatório Clear Sale")
  end
end

