# -*- encoding : utf-8 -*-
class CampaignEmailNotificationMailer < ActionMailer::Base
  default :from => "olook <bemvinda@my.olookmail.com.br>"

  def welcome_email(email)
    mail(:to => email, :subject => "Recebemos seu e-mail. Agora é hora de descobrir o seu estilo.")
    headers["X-SMTPAPI"] = { 'category' => 'welcome_email' }.to_json
  end

  def olookmovel_welcome_email(email)
    mail(:to => email, :subject => "Recebemos seu e-mail. Agora é hora de descobrir o seu estilo.")
    headers["X-SMTPAPI"] = { 'category' => 'welcome_email' }.to_json
  end

end
