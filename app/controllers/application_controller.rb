# -*- encoding : utf-8 -*-
class ApplicationController < ActionController::Base
  protect_from_forgery
  layout "site"
  before_filter :load_user
  before_filter :load_cart
  before_filter :load_facebook_api
  before_filter :load_referer

  rescue_from CanCan::AccessDenied do  |exception|
      flash[:error] = "Access Denied! You don't have permission to execute this action.
                              Contact the system administrator"
      redirect_to admin_url
  end

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
      cart.update_attribute("notified", true)
    end
    
    # #inject sessions states
    # cart.gift_wrap = session[:gift_wrap]
    # cart.used_coupon = session[:cart_coupon]
    
    if @user
      cart.update_attribute("user_id", @user.id) if cart.user.nil?
    end

    @promotion = PromotionService.new(@user).detect_current_promotion
    
    session[:credits] = 0 unless session[:credits]
    
    @cart_service = CartService.new(
      :cart => cart,
      :gift_wrap => session[:gift_wrap],
      :coupon => session[:cart_coupon].reload,
      :promotion => @promotion,
      :freight => session[:cart_freight],
      :credits => session[:cart_credits]
    )

    cart.coupon = session[:cart_coupon]
    cart.promotion = @promotion
    
    
    # cart.credits = session[:credits]
    # cart.freight = session[:freight]
    
    cart
  end

  helper_method :current_moment
  def current_moment
    Moment.active.first
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
  
  helper_method :current_referer
  def current_referer
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
    
    if @cart.has_gift_items?
      session[:return_to] ||= { text: "Voltar para as sugestões", url: gift_recipient_suggestions_path(session[:recipient_id]) }
    elsif @user && !@user.half_user?
      session[:return_to] ||= { text: "Voltar para a minha vitrine", url: member_showroom_path }
    else
      session[:return_to] ||= { text: "Voltar para tendências", url: lookbooks_path }
    end
  end

  private
  def load_facebook_api
    @facebook_app_id = FACEBOOK_CONFIG["app_id"]
  end
  
  def load_referer
    @referer = current_referer
  end

  def load_user
    @user = current_user
  end

  def load_cart
    @cart = current_cart
  end

  def current_ability
    @current_ability ||= ::Ability.new(current_admin)
  end
end

