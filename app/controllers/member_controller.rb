class MemberController < ApplicationController
  before_filter :validate_token, :only => :accept_invitation

  def invite
    @member = current_user
  end

  def accept_invitation
    session[:invite] = {:invite_token => params[:invite_token],
                        :invited_by => @inviting_member.name}
    redirect_to new_user_registration_path
  end

  private  
  def validate_token
    valid_format = User::InviteTokenFormat.match params[:invite_token]

    @inviting_member = User.find_by_invite_token(params[:invite_token]) if valid_format

    redirect_to(:root, :alert => "Invalid token") unless valid_format && @inviting_member
  end
end
