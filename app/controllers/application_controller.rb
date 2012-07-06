# -*- encoding : utf-8 -*-
class ApplicationController < ActionController::Base
  protect_from_forgery
  layout "site"
  before_filter :load_user
  before_filter :load_cart
  before_filter :load_promotion
  before_filter :save_referer
  before_filter :current_referer
  before_filter :load_facebook_api

  rescue_from Contacts::AuthenticationError, :with => :contact_authentication_failed
  rescue_from GData::Client::CaptchaError, :with => :contact_authentication_failed
  #rescue_from ActiveRecord::RecordNotFound, :with => :render_404
  #rescue_from ActionController::UnknownController, :with => :render_404
  #rescue_from ::AbstractController::ActionNotFound, :with => :render_404
  rescue_from CanCan::AccessDenied do  |exception|
      flash[:error] = "Access Denied! You don't have permission to execute this action.
                              Contact the system administrator"
      redirect_to admin_url
  end
  #rescue_from Exception, :with => :render_500

  helper_method :current_liquidation
  def current_liquidation
    LiquidationService.active
  end

  helper_method :current_cart
  def current_cart
    #ORDER_ID IN PARAMS BECAUSE HAVE EMAIL SEND IN PAST
    cart_id = params[:order_id] || session[:cart_id]
    cart = Cart.find_by_id(cart_id)
    # order = current_user.orders.find_by_id(order_id)
    cart ||= Cart.create(user: @user)
    
    session[:cart_id] = cart.id
    #not sending email in the case of a buy made from an admin
    if current_admin
      cart.update_attribute("in_cart_notified", true)
    end
    
    #inject sessions states
    
    cart.gift_wrap = session[:gift_wrap]
    cart.used_coupon = session[:session_coupon]
    
    cart
  end

  helper_method :current_moment
  def current_moment
    Moment.active.first
  end

  def facebook_redirect_paths
    {:friends => friends_home_path, :gift => gift_root_path, :showroom => member_showroom_path}
  end

  def render_public_exception
    case env["action_dispatch.exception"]
      when ActiveRecord::RecordNotFound, ActionController::UnknownController,
        ::AbstractController::ActionNotFound
        render :template => "/errors/404.html.erb", :layout => 'error', :status => 404
      else
        render :template => "/errors/500.html.erb", :layout => 'error', :status => 500
    end
  end

  private

  def contact_authentication_failed
    flash[:notice] = "Falha de autenticação na importação de contatos"
    redirect_to :back
  end

  protected

  def load_facebook_api
    @facebook_app_id = FACEBOOK_CONFIG["app_id"]
  end

  def load_user
    @user = current_user
  end

  def load_cart
    @cart = current_cart
  end

  def load_promotion
    if @user and not @user.half_user
      @promotion = PromotionService.new(@user).detect_current_promotion
    elsif !@user
      @promotion = Promotion.purchases_amount
    end
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

