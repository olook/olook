# -*- encoding : utf-8 -*-
class MembersController < ApplicationController

  before_filter :check_url, :only => [:showroom, :showroom_shoes, :showroom_bags, :showroom_accessories]
  before_filter :authenticate_user!, :except => [:accept_invitation]
  before_filter :load_facebook_adapter
  rescue_from Contacts::AuthenticationError, :with => :contact_authentication_failed
  rescue_from GData::Client::CaptchaError, :with => :contact_authentication_failed

  def invite
    @redirect_uri = root_path

    yahoo_request = OauthImport::Yahoo.new.request
    if yahoo_request
      session['yahoo_request_token'], session['yahoo_request_secret'] = yahoo_request.token, yahoo_request.secret
      @yahoo_oauth_url = yahoo_request.authorize_url
    end
  end

  def accept_invitation
    valid_format = User::InviteTokenFormat.match params[:invite_token]
    @inviting_member = User.find_by_invite_token(params[:invite_token]) if valid_format
    return redirect_to(root_path, :alert => "Convite inválido") unless valid_format && @inviting_member
    session[:invite] = {:invite_token => params[:invite_token], :invited_by => @inviting_member.name}
    incoming_params = params.clone.delete_if { |key| ['controller', 'action','invite_token'].include?(key) }
    redirect_to root_path(incoming_params)
  end

  def invite_by_email
    parsed_emails = params[:invite_mail_list].split(/,|;|\r|\t/).map(&:strip)
    invites = current_user.invites_for(parsed_emails)
    current_user.add_event(EventType::SEND_INVITE, "#{invites.length} invites sent")
    redirect_to(:back, :notice => "#{invites.length} convites enviados com sucesso!")
  end

  def new_member_invite_by_email
    parsed_emails = params[:invite_mail_list].split(/,|;|\r|\t/).map(&:strip)
    invites = current_user.invites_for(parsed_emails)
    current_user.add_event(EventType::SEND_INVITE, "#{invites.length} invites sent")
    redirect_to(member_welcome_path, :notice => "#{invites.length} convites enviados com sucesso!")
  end

  # I know it's a workaround, but our friends at yahoo did us
  # the favor of GET the allowed app giving params, not POST it.
  # -zanst
  def import_contacts
    begin
      email_provider = "yahoo"
      oauth_token = params[:oauth_token]
      oauth_secret = session['yahoo_request_secret']
      oauth_verifier = params[:oauth_verifier]
      contacts_adapter = ContactsAdapter.new(nil, nil, oauth_token, oauth_secret, oauth_verifier)
      @contacts = contacts_adapter.contacts(email_provider)
    rescue MultiJson::DecodeError, Net::HTTPFatalError, OAuth::Problem
      redirect_to(member_invite_path, :notice => "Seus contatos não puderam ser importados agora. Por favor tente novamente mais tarde.")
    end
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
    redirect_to(member_invite_path, :notice => "#{invites.length} Convites enviados com sucesso!")
  end

  def welcome
    session[:facebook_redirect_paths] = "showroom"
    @show_liquidation_lightbox = UserLiquidationService.new(current_user, current_liquidation).show?
    @lookbooks = Lookbook.where("active = 1").order("created_at DESC")
  end

  def showroom
    if @user.half_user
      if @user.female?
        return render "/home/index"
      else
        return redirect_to lookbooks_path, :alert => flash[:notice]
      end
    end

    session[:facebook_redirect_paths] = "showroom"
    @is_retake = session[:profile_retake] ? true : false
    session[:profile_retake] = false
    @show_liquidation_lightbox = UserLiquidationService.new(current_user, current_liquidation).show?
    @lookbooks = Lookbook.where("active = 1").order("created_at DESC")
    if @facebook_adapter
      @friends = @facebook_adapter.facebook_friends_registered_at_olook rescue []
    end
  end

  def showroom_shoes
  end

  def showroom_bags
  end

  def showroom_accessories
  end

  def loyalty
  end

  def earn_credits
  end

  def credits
  end

  def invite_list
    @invites = @user.invites.page(params[:page]).per_page(15)
  end

  private
  def contact_authentication_failed
    flash[:notice] = "Falha de autenticação na importação de contatos"
    redirect_to :back
  end

  def check_url
    @url = request.protocol + request.host
    @url += ":" + request.port.to_s if request.port != 80
  end

  def load_facebook_adapter
    if @user && @user.has_facebook?
      @facebook_adapter = FacebookAdapter.new @user.facebook_token
    end
  end
end

