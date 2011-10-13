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
end
