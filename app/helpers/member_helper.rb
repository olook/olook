# -*- encoding : utf-8 -*-
module MemberHelper
  def link_to_invitation(member)
    "\"#{invite_message} #{invitation_link(member)}\""
  end

  def invitation_link(member)
    link = "http://beta.olook.com.br/invite/#{member.invite_token}"
  end

  def invite_message
    message = "Venha ver minha vitrine na olook! Entre no link."
  end
  
  def invitation_score(member)
    accept_invite_count = member.invites.accepted.count
    if accept_invite_count == 0
      raw(I18n.t('interface.member.no_invitation_accepted'))
    else
      raw(I18n.t('interface.member.invitation_accepted', :count => accept_invite_count, :bonus => number_to_currency(member.invite_bonus)))
    end
  end
end
