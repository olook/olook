# -*- encoding : utf-8 -*-
module MemberHelper
  def twitte_message(member)
    "Cadastre-se na olook pelo meu convite: #{accept_invitation_url(:invite_token => member.invite_token)}, descubra o seu estilo e ainda ganhe R$10! #ficaadica"
  end

  def link_to_invitation(member)
    "\"#{invite_message} #{invitation_link(member)}\""
  end

  def invitation_link(member)
    link = accept_invitation_url(member.invite_token)
  end

  def invite_message
    message = "Venha ver minha vitrine na olook! Entre no link."
  end
  
  def display_member_invite_bonus(member)
    if member.invite_bonus > 0
      raw(I18n.t('views.members.member_with_invite_bonus', :bonus => number_to_currency(member.invite_bonus)))
    else
      raw(I18n.t('views.members.member_with_no_invite_bonus'))
    end
  end
  
  def invitation_score(member)
    accept_invite_count = member.invites.accepted.count
    invite_bonus = member.invite_bonus
    
    if accept_invite_count == 0
      if invite_bonus > 0
        raw(I18n.t('views.members.bonus_for_accepting_invite'))
      else
        raw(I18n.t('views.members.no_invitation_accepted'))
      end
    else
      raw(I18n.t('views.members.invitation_accepted', :count => accept_invite_count, :bonus => number_to_currency(invite_bonus)))
    end
  end

  def first_visit_banner
    profile = current_user.profile_scores.first.try(:profile)
    profile.nil? ? "" : "/assets/first_visit_banner/#{profile.first_visit_banner}.jpg"
  end

  def domain_url
    "http://www.olook.com.br"
  end

  def first_visit_profile
    profile = current_user.profile_scores.first.try(:profile).first_visit_banner
  end
end
