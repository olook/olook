# -*- encoding : utf-8 -*-
class Admin::UserExportMailer < ActionMailer::Base
  default :from => "Admin Olook <admin@olook.com.br>"

  def csv_ready(email)
    @file_url = "http://app1.olook.com.br/admin/users.csv"
    mail(:to => email, :subject => "Arquivo CSV com os usuários está pronto")
  end
end
