class MemberController < ApplicationController
  def invite
    @member = current_user
  end

  def accept_invitation(invitation_token)
    
  end
end
