# -*- encoding : utf-8 -*-
class MGMMailer < ActionMailer::Base
  default_url_options[:host] = "www.olook.com.br"
  default :from => "olook <avisos@olook.com.br>"

  def self.smtp_settings
    {
      :user_name => "AKIAJJO4CTAEHYW34HGQ",
      :password => "AkYlOmgbIpISW33XVzQq8d9J4GnAgtQlEJuwgIxOFXmU",
      :address => "email-smtp.us-east-1.amazonaws.com",
      :port => 587,
      :authentication => :plain,
      :enable_starttls_auto => true
    }
  end

  def send_registered_invitee_notification(invitee)
    @inviter = invitee.try(:inviter)
    @invitee = invitee
    #@credits = Setting.invite_credits_bonus_for_inviter
    mail(:to => @inviter.email, :subject => "#{invitee.first_name} se cadastrou pelo seu convite!")
  end

  def send_first_purchase_by_invitee_notification(invitee)
    @inviter = invitee.try(:inviter)
    @invitee = invitee    
    #@credits = Setting.invite_credits_bonus_for_inviter
    mail(:to => invitee.email, :subject => "#{invitee.first_name} fez uma compra e você ganhou R$ 20.")
  end

  

end
