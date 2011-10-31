# -*- encoding : utf-8 -*-
class MembersController < ApplicationController

  before_filter :authenticate_user!, :except => [:accept_invitation]
  before_filter :validate_token, :only => :accept_invitation

  def invite
    @member = current_user
    @facebook_app_id = FACEBOOK_CONFIG["app_id"]
  end

  def accept_invitation
    session[:invite] = {:invite_token => params[:invite_token],
                        :invited_by => @inviting_member.name}
    redirect_to new_user_registration_path
  end

  def invite_by_email
    parsed_emails = params[:invite_mail_list].split(',').map(&:strip)
    invites = current_user.invites_for(parsed_emails)
    current_user.add_event(EventType::SEND_INVITE, "#{invites.length} invites sent")
    redirect_to(member_invite_path, :notice => "#{invites.length} convites enviados com sucesso!")
  end

  def show_imported_contacts
    email_provider = params[:email_provider]
    login = params[:login]
    password = params[:password]
    contacts_adapter = ContactsAdapter.new(login, password)
    @contacts = contacts_adapter.contacts(email_provider)
  end

  def invite_imported_contacts
    invites = current_user.invites_for(params[:email_address])
    current_user.add_event(EventType::SEND_IMPORTED_CONTACTS, "#{invites.length} invites from imported contacts sent")
    redirect_to(member_import_contacts_path, :notice => "Convites enviados com sucesso!")
  end

  def invite_list
    @member = current_user
    @invites = @member.invites.page(params[:page]).per_page(15)
  end

  private

  def validate_token
    valid_format = User::InviteTokenFormat.match params[:invite_token]
    @inviting_member = User.find_by_invite_token(params[:invite_token]) if valid_format
    redirect_to(member_invite_path, :alert => "Convite inválido") unless valid_format && @inviting_member
  end
end
