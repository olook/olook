# -*- encoding : utf-8 -*-
module MemberHelper
  def link_to_invitation(member)
    "\"Venha ver minha vitrine na olook! Visite olook.com/invite/#{member.invite_token}\""
  end
end
