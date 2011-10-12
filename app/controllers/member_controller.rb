# -*- encoding : utf-8 -*-
class MemberController < ApplicationController

  before_filter :authenticate_user!, :except => [:accept_invitation]
  before_filter :validate_token, :only => :accept_invitation

  def invite
    @member = current_user
  end

  def accept_invitation
    session[:invite] = {:invite_token => params[:invite_token],
                        :invited_by => @inviting_member.name}
    redirect_to new_user_registration_path
  end

  def invite_by_email
    parsed_emails = params[:invite_mail_list].split(',').map(&:strip)
    invites = current_user.invites_for(parsed_emails)
    invites.each(&:send_invitation)
    redirect_to(member_invite_path, :notice => "#{invites.length} convites enviados com sucesso!")
  end

  def show_imported_contacts
    email_provider = params[:email_provider]
    login = params[:login]
    password = params[:password]

    case email_provider.to_i
      when 1
        @contacts = Contacts::Gmail.new(login, password).contacts
      when 2
        @contacts = Contacts::Yahoo.new(login, password).contacts
    end
  end

  def invite_imported_contacts
    invites = current_user.invites_for(params[:email_address])
    invites.each(&:send_invitation)
    redirect_to(member_import_contacts_path, :notice => "Convites enviados com sucesso!")
  end

  private

  def validate_token
    valid_format = User::InviteTokenFormat.match params[:invite_token]

    @inviting_member = User.find_by_invite_token(params[:invite_token]) if valid_format

    redirect_to(:root, :alert => "Invalid token") unless valid_format && @inviting_member
  end
end
