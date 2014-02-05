# -*- encoding : utf-8 -*-
class MemberMailer < ActionMailer::Base
  default :from => "olook <bemvinda@my.olookmail.com.br>"

  def reseller_welcome_email(reseller)
    @reseller = reseller
    mail(:to => @reseller.email, :subject => "RECEBEMOS SEU CADASTRO!")
  end

  def reseller_confirmation(reseller)
    @reseller = reseller
    mail(:to => @reseller.email, :subject => "Revenda Olook")
  end

  def welcome_email(member)
    @member = member
    default_welcome_email
  end

  alias :welcome_gift_half_male_user_email :welcome_email
  alias :welcome_thin_half_male_user_email :welcome_email
  alias :welcome_gift_half_female_user_email :welcome_email
  alias :welcome_thin_half_female_user_email :welcome_email

  private

  def default_welcome_email
    mail(:to => @member.email, :subject => subject_by_gender_and_kind)
    headers["X-SMTPAPI"] = { 'category' => 'welcome_email' }.to_json
  end

  def subject_by_gender_and_kind
    if @member.half_user
      "#{@member.name}, seja bem vind#{@member.male? ? 'o' : 'a'}! Seu cadastro foi feito com sucesso!"
    else
      "#{@member.name}, bem vinda! Agora que sabemos o seu estilo..."
    end
  end
end
