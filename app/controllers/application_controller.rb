# -*- encoding : utf-8 -*-
class ApplicationController < ActionController::Base
  protect_from_forgery
  layout "site"
  before_filter :load_promotion
  before_filter :clean_token
  before_filter :save_referer
  before_filter :current_referer

  rescue_from Contacts::AuthenticationError, :with => :contact_authentication_failed
  rescue_from GData::Client::CaptchaError, :with => :contact_authentication_failed
  rescue_from Koala::Facebook::APIError, :with => :facebook_api_error


  helper_method :current_liquidation
  def current_liquidation
    LiquidationService.active
  end

  helper_method :current_moment
  def current_moment
    Moment.active.first
  end

  def clean_token
    if params[:auth_token] && current_user
      current_user.authentication_token = nil
      current_user.save
    end
  end

  def load_promotion
    if current_user and not current_user.half_user
      @promotion = PromotionService.new(current_user).detect_current_promotion
    end
  end

  rescue_from CanCan::AccessDenied do  |exception|
      flash[:error] = "Access Denied! You don't have permission to execute this action.
                              Contact the system administrator"
      redirect_to admin_url
   end

  private

  def facebook_api_error
    session[:facebook_scopes] = "publish_stream"
    head :error
  end

  def contact_authentication_failed
    flash[:notice] = "Falha de autenticação na importação de contatos"
    redirect_to :back
  end

  protected
  
  def redirect_if_half_user
    if current_user.half_user
      redirect_to lookbooks_path 
    end
  end
  
  # TODO: Temporarily disabling paper_trail for app analysis
  # def user_for_paper_trail
  #   user_signed_in? ? current_user : current_admin
  # end

  def load_user
    @user = current_user
  end

  def load_order
    @order = current_user.orders.find_by_id(session[:order]) if current_user
  end

  def check_early_access
    redirect_to member_invite_path if current_user && !current_user.has_early_access?
  end

  def assign_default_country
    params[:address][:country] = 'BRA'
  end

  def current_ability
    @current_ability ||= ::Ability.new(current_admin)
  end

  def save_referer
    session[:return_to] = case request.referer
      when /produto|sacola/ then
        session[:return_to] ? session[:return_to] : nil
      when /moments/ then
        { text: "Voltar para ocasiões", url: moments_path }
      when /suggestions/ then
        session[:recipient_id] ? { text: "Voltar para as sugestões", url: gift_recipient_suggestions_path(session[:recipient_id]) } : nil
      when /gift/ then
        { text: "Voltar para presentes", url: gift_root_path }
      else
        nil
    end
    session[:return_to] ||= { text: "Voltar para a minha vitrine", url: member_showroom_path }
  end

  def current_referer
    @referer = session[:return_to]
  end

end

