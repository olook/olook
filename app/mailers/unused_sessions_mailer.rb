# -*- encoding : utf-8 -*-
class UnusedSessionsMailer < ActionMailer::Base
  default from: "tiago.almeida@olook.com.br"

  def send_notification starting_date
    @formatted_starting_date = starting_date.strftime("%d-%m-%Y")
    mail(:to => Setting.unused_sessions_email, :subject => "Sessoes de #{@formatted_starting_date} Removidas com Sucesso!")
  end
end
