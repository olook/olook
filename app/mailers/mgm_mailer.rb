# -*- encoding : utf-8 -*-
class MGMMailer < ActionMailer::Base
  default_url_options[:host] = "www.olook.com.br"
  default :from => "olook <avisos@olook.com.br>"

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
    mail(:to => @inviter.email, :subject => "#{invitee.first_name} fez uma compra e você ganhou R$ 20.")
  end

  

end
