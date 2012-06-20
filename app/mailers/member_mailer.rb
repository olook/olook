# -*- encoding : utf-8 -*-
class MemberMailer < ActionMailer::Base
  default :from => "olook <avisos@my.olookmail.com>"

  def self.smtp_settings
    {
      :user_name => "olook2",
      :password => "olook123abc",
      :domain => "my.olookmail.com",
      :address => "smtp.sendgrid.net",
      :port => 587,
      :authentication => :plain,
      :enable_starttls_auto => true

    }
  end

  def welcome_email(member)
    default_welcome_email(member)
  end

  def welcome_gift_half_male_user_email(member)
    default_welcome_email(member)
    #mail( :to => member.email,
          #:from => "olook <bemvindo@olook1.com.br>",
          #:subject => "#{member.name}, seja bem vindo! Seu cadastro foi feito com sucesso!"
          #)
  end

  def welcome_gift_half_female_user_email(member)
    default_welcome_email(member)
  end

  def welcome_thin_half_female_user_email(member)
    default_welcome_email(member)
  end

  def welcome_thin_half_male_user_email(member)
    default_welcome_email(member)
  end

  private
  def default_welcome_email member
    @member = member
    mail( :to => member.email,
          :from => "olook <bemvinda@olook1.com.br>",
          :subject => "#{member.name}, seja bem vinda! Seu cadastro foi feito com sucesso!"
          )
    headers["X-SMTPAPI"] = { 'category' => 'welcome_email' }.to_json
  end
end
