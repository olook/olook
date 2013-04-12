# -*- encoding : utf-8 -*-
class BilletSummaryMailer < ActionMailer::Base
  default from: "tiago.almeida@olook.com.br"

  def send_billet_summary(billet_hash)
    @billet_hash = billet_hash
    mail(:to => Setting.billet_summary_email, :subject => "Sumário de Boletos Santander")
  end
end
