# -*- encoding : utf-8 -*-
class ApplicationController < ActionController::Base
  protect_from_forgery
  layout "site"

  before_filter :load_user,
                :create_cart,
                :load_cart,
                :load_coupon,
                :load_cart_service,
                :load_facebook_api,
                :load_referer,
                :load_tracking_parameters,
                :set_modal_show,
                :load_campaign_email_if_user_is_not_logged

  helper_method :current_liquidation,
                :show_current_liquidation?,
                :show_current_liquidation_advertise?,
                :current_cart,
                :current_referer,
                :title_text,
                :canonical_link
  around_filter :log_start_end_action_processing

  rescue_from CanCan::AccessDenied do  |exception|
    flash[:error] = "Access Denied! You don't have permission to execute this action.
    Contact the system administrator"
    redirect_to admin_url
  end

  def render_public_exception
    Rails.logger.debug('ApplicationController#render_public_exception')
    case env["action_dispatch.exception"]
      when ActiveRecord::RecordNotFound, ActionController::UnknownController,
        ::AbstractController::ActionNotFound
        render :template => "/errors/404.html.erb", :layout => 'error', :status => 404
      else
        render :template => "/errors/500.html.erb", :layout => 'error', :status => 500
    end
  end

  # making this method public so it can be stubbed in tests
  # TODO: find a way to stub without this ugly hack
  def current_cart
    Rails.logger.debug('ApplicationController#current_cart')
    #ORDER_ID IN PARAMS BECAUSE HAVE EMAIL SEND IN PAST
    cart_id_session = session[:cart_id]
    cart_id_params = params[:cart_id]
    cart_id_legacy = params[:order_id]

    cart = @user.carts.find_by_id(cart_id_params)  if @user && cart_id_params
    cart = @user.carts.find_by_legacy_id(cart_id_legacy)  if @user && cart_id_legacy

    cart ||= Cart.find_by_id(cart_id_session) if cart_id_session

    cart = assign_coupon_to_cart(cart, params[:coupon_code]) if params[:coupon_code]

    assign_cart_to_user(cart) if cart

    cart
  end

  def set_modal_show
    if params[:modal] || params[:coupon_code].present?
      @modal_show = params[:modal] != "0" ? "1" : "0"
    else
      @modal_show = cookies[:ms].blank? ? "1" : "0"
    end
  end

  protected

    def title_text
      Seo::SeoManager.new(request.path).select_meta_tag
    end

    def canonical_link
      if request.fullpath.match('\?')
        "#{request.protocol}#{request.host_with_port}#{request.path}"
      end
    end

    def assign_coupon_to_cart(cart, coupon_code)
      coupon = Coupon.find_by_code(coupon_code)
      if coupon
        cart ||= create_cart
        cart.coupon_code = coupon.code
        if cart.valid?
          cart.update_attributes(:coupon_id => coupon.id)
          @show_coupon_warn = true
        else
          flash.now[:notice] = cart.errors[:coupon_code].join('<br />'.html_safe)
          cart.remove_coupon!
        end
      else
        flash.now[:notice] = 'Cupom Inválido'
      end
      cart
    end

    def assign_cart_to_user(cart)
      if cart && @user
        cart.update_attribute("user_id", @user.id) if cart.user.nil?
      end
    end

    def log_start_end_action_processing
      Rails.logger.debug("START #{params[:controller].to_s.camelize}Controller##{params[:action]}")
      yield
      Rails.logger.debug("END #{params[:controller].to_s.camelize}Controller##{params[:action]}")
    end

    def create_cart
      Rails.logger.debug('ApplicationController#create_cart')
      cart_id_session = session[:cart_id]
      cart ||= Cart.find_by_id(cart_id_session) if cart_id_session
      cart ||= Cart.create(user: current_user)
      session[:cart_id] = cart.id
      cart
    end

    def current_liquidation
      Rails.logger.debug('ApplicationController#current_liquidation')
      LiquidationService.active
    end

    def show_current_liquidation?
      Rails.logger.debug('ApplicationController#show_current_liquidation?')
      current_liquidation.try(:visible?)
    end

    def show_current_liquidation_advertise?
      Rails.logger.debug('ApplicationController#show_current_liquidation_advertise?')
      current_liquidation.try(:show_advertise?)
    end

    def current_referer
      Rails.logger.debug('ApplicationController#current_referer')
      session[:return_to] = case request.referer
        when /produto|sacola/ then
          session[:return_to] ? session[:return_to] : nil
        when /colecoes/ then
          { text: "Voltar para coleções", url: collection_themes_path }
        when /suggestions/ then
          session[:recipient_id] ? { text: "Voltar para as sugestões", url: gift_recipient_suggestions_path(session[:recipient_id]) } : nil
        when /gift/ then
          { text: "Voltar para presentes", url: gift_root_path }
        else
          nil
      end

      if @cart && @cart.has_gift_items?
        session[:return_to] ||= { text: "Voltar para as sugestões", url: gift_recipient_suggestions_path(session[:recipient_id]) }
      elsif @user && !@user.half_user?
        session[:return_to] ||= { text: "Voltar para a minha vitrine", url: member_showroom_path }
      else
        session[:return_to] ||= { text: "Voltar para coleções", url: collection_themes_path }
      end
    end

    def load_coupon
      Rails.logger.debug('ApplicationController#load_coupon')
      if @cart
        @coupon = @cart.coupon
        @coupon.reload if @coupon
      end
    end

    def load_cart_service
      Rails.logger.debug('ApplicationController#load_cart_service')
      @cart_service = CartService.new(
        :cart => @cart
      )
    end

    def load_facebook_api
      Rails.logger.debug('ApplicationController#load_facebook_api')
      @facebook_app_id = FACEBOOK_CONFIG["app_id"]
    end

    def load_referer
      Rails.logger.debug('ApplicationController#load_referer')
      @referer = current_referer
    end

    def load_user
      Rails.logger.debug('ApplicationController#load_user')
      @user = current_user
    end

    def load_campaign_email_if_user_is_not_logged
      @campaign_email = CampaignEmail.new if @user.nil?
    end

    def load_cart
      Rails.logger.debug('ApplicationController#load_cart')
      @cart = current_cart
    end

    def current_ability
      Rails.logger.debug('ApplicationController#current_ability')
      @current_ability ||= ::Ability.new(current_admin)
    end

    def logged_in?
      Rails.logger.debug('ApplicationController#logged_in?')
      current_user
    end

    def load_tracking_parameters
      Rails.logger.debug('ApplicationController#load_tracking_parameters')
      incoming_params = params.clone.delete_if {|key| ['controller', 'action'].include?(key) }
      incoming_params[:referer] = request.referer unless request.referer.nil?
      session[:tracking_params] = incoming_params if session[:tracking_params].nil? || session[:tracking_params].empty?
      session[:order_tracking_params] = incoming_params if incoming_params.has_key?("utm_source") || external_referer?(request.referer)
    end

    def external_referer?(referer)
      Rails.logger.debug('ApplicationController#external_referer?(referer)')
      return false if referer.nil?
      !(referer =~ /olook\.com\.br/)
    end

    def prepare_for_home
      Rails.logger.debug('ApplicationController#prepare_for_home')
      @top5 = Product.fetch_products :top5
      @stylist = Product.fetch_products :selection
      @concept = Product.fetch_products :concept
      @highlights = Highlight.highlights_to_show HighlightType::CAROUSEL
      @weekly_highlights = Highlight.highlights_to_show HighlightType::WEEKLY

      if params[:share]
        @user = User.find(params[:uid])
        @profile = @user.profile_scores.first.try(:profile).try(:first_visit_banner)
        @qualities = Profile::DESCRIPTION["#{@profile}"]
        @url = request.protocol + request.host
      end
      @incoming_params = params.clone.delete_if {|key| ['controller', 'action'].include?(key) }
      session[:tracking_params] ||= @incoming_params
    end
end

