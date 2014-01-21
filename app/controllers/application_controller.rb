# -*- encoding : utf-8 -*-
class ApplicationController < ActionController::Base
  protect_from_forgery
  layout "lite_application"

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

  helper_method :mobile?,
                :current_cart,
                :current_referer,
                :title_text,
                :canonical_link,
                :meta_description,
                :has_wished?,
                :empty_wishlist?

  around_filter :log_start_end_action_processing

  rescue_from CanCan::AccessDenied do  |exception|
    flash[:error] = "Access Denied! You don't have permission to execute this action.
    Contact the system administrator"
    redirect_to admin_url
  end

  protected

    def empty_wishlist?
      Wishlist.for(current_user).wished_products.empty?
    end

    def has_wished? product_id
      if current_user
        Wishlist.for(current_user).has?(product_id)
      else
        false
      end
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


    def title_text
      Seo::SeoManager.new(request.path).select_meta_tag
    end

    def canonical_link
      if request.fullpath.match('\?')
        "#{request.protocol}#{request.host_with_port}#{request.path}"
      end
    end

    def meta_description
      "Roupas femininas, sapatos, bolsas, óculos e acessórios incríveis - Olook. Seu look, seu estilo"
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

  def mobile?

    user_agent = request.user_agent ? request.user_agent[0..3] : ""

    !!(/(android|bb\d+|meego).+mobile|avantgo|bada\/|blackberry|blazer|compal|
    elaine|fennec|hiptop|iemobile|ip(hone|od)|iris|kindle|lge\ |maemo|midp|
    mmp|mobile.+firefox|netfront|opera\ m(ob|in)i|palm(\ os)?|phone|p(ixi|re)\/|
    plucker|pocket|psp|series(4|6)0|symbian|treo|up\.(browser|link)|vodafone|
    wap|windows\ (ce|phone)|xda|xiino/xi.match(request.user_agent) ||
      /1207|6310|6590|3gso|4thp|50[1-6]i|770s|802s|a\ wa|abac|ac(er|oo|s\-)|
      ai(ko|rn)|al(av|ca|co)|amoi|an(ex|ny|yw)|aptu|ar(ch|go)|as(te|us)|attw|
      au(di|\-m|r\ |s\ )|avan|be(ck|ll|nq)|bi(lb|rd)|bl(ac|az)|br(e|v)w|bumb|
      bw\-(n|u)|c55\/|capi|ccwa|cdm\-|cell|chtm|cldc|cmd\-|co(mp|nd)|
      craw|da(it|ll|ng)|dbte|dc\-s|devi|dica|dmob|do(c|p)o|ds(12|\-d)|el(49|ai)|
      em(l2|ul)|er(ic|k0)|esl8|ez([4-7]0|os|wa|ze)|fetc|fly(\-|_)|g1\ u|g560|
      gene|gf\-5|g\-mo|go(\.w|od)|gr(ad|un)|haie|hcit|hd\-(m|p|t)|hei\-|hi(pt|ta)|
        hp(\ i|ip)|hs\-c|ht(c(\-|\ |_|a|g|p|s|t)|tp)|hu(aw|tc)|i\-(20|go|ma)|i230|
      iac(\ |\-|\/)|ibro|idea|ig01|ikom|im1k|inno|ipaq|iris|ja(t|v)a|jbro|
      jemu|jigs|kddi|keji|kgt(\ |\/)|klon|kpt\ |kwc\-|kyo(c|k)|le(no|xi)|
        lg(\ g|\/(k|l|u)|50|54|\-[a-w])|libw|lynx|m1\-w|m3ga|m50\/|
      ma(te|ui|xo)|mc(01|21|ca)|m\-cr|me(rc|ri)|mi(o8|oa|ts)|mmef|
      mo(01|02|bi|de|do|t(\-|\ |o|v)|zz)|mt(50|p1|v\ )|mwbp|mywa|n10[0-2]|
        n20[2-3]|n30(0|2)|n50(0|2|5)|n7(0(0|1)|10)|ne((c|m)\-|on|tf|wf|wg|wt)|
        nok(6|i)|nzph|o2im|op(ti|wv)|oran|owg1|p800|pan(a|d|t)|pdxg|
      pg(13|\-([1-8]|c))|phil|pire|pl(ay|uc)|pn\-2|po(ck|rt|se)|prox|
      psio|pt\-g|qa\-a|qc(07|12|21|32|60|\-[2-7]|i\-)|qtek|r380|r600|
      raks|rim9|ro(ve|zo)|s55\/|sa(ge|ma|mm|ms|ny|va)|sc(01|h\-|oo|p\-)|
        sdk\/|se(c(\-|0|1)|47|mc|nd|ri)|sgh\-|shar|sie(\-|m)|sk\-0|sl(45|id)|
        sm(al|ar|b3|it|t5)|so(ft|ny)|sp(01|h\-|v\-|v\ )|sy(01|mb)|t2(18|50)|
        t6(00|10|18)|ta(gt|lk)|tcl\-|tdg\-|tel(i|m)|tim\-|t\-mo|to(pl|sh)|
        ts(70|m\-|m3|m5)|tx\-9|up(\.b|g1|si)|utst|v400|v750|
      veri|vi(rg|te)|vk(40|5[0-3]|\-v)|vm40|voda|vulc|vx(52|53|60|61|70|80|81|83|85|98)|
        w3c(\-|\ )|webc|whit|wi(g\ |nc|nw)|wmlb|
      wonu|x700|yas\-|your|zeto|zte\-/xi.match(user_agent))
  end

  def prepare_freights(freights)
    @shipping_service = OpenStruct.new freights.fetch(:default_shipping)
    if freights.count > 1
      @has_two_shipping_services = true
      @shipping_service_fast = OpenStruct.new freights.fetch(:fast_shipping)
    end
  end

end

