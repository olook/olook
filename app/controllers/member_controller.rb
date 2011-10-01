class MemberController < ApplicationController
  before_filter :validate_token, :only => :accept_invitation

  def invite
    @member = current_user
  end

  def accept_invitation
    
  end

  private  
  def validate_token
    valid_format = User::InviteTokenFormat.match params[:invite_token]
    
    valid_token = User.find_by_invite_token(params[:invite_token]) if valid_format

    redirect_to(:root, :alert => "Invalid token") unless valid_format && valid_token
  end
end
