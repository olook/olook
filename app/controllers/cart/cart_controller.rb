# -*- encoding : utf-8 -*-
class Cart::CartController < ApplicationController
  layout "lite_application"

  respond_to :html, :js, :json
  skip_before_filter :authenticate_user!, :only => :add_variants

  def show
    @google_path_pixel_information = "cart"
    @google_pixel_information = @cart
    @report  = CreditReportService.new(@user)
    @url = request.protocol + request.host
    @url += ":" + request.port.to_s if request.port != 80

    # apenas para parar de dar erro
    if @cart.nil? 
      @cart = create_cart
      load_cart_service
    end

    @chaordic_cart = ChaordicInfo.cart(@cart, current_user, cookies[:ceid])
    @cart_calculator = CartProfit::CartCalculator.new(@cart)
    @promo_over_coupon = false
    if @cart.coupon_id && Promotion.select_promotion_for(@cart)
      @promo_over_coupon = true
    end

    @return_url = session[:search_url] || catalog_url((@cart.items.first.try(:product).try(:category_humanize) || 'sapato').parameterize)

    @freebie = Freebie.new(subtotal: @cart.sub_total, cart_id: @cart.id)

    @checkout_ab_test = ab_test("checkout_test", 'default', {'new' => Setting.defaults[:percent_for_new_checkout]})
    respond_to do |format|
      format.html { render :show }
      format.json { render json: @cart.to_json }
    end
  end

  def destroy
    @cart.destroy
    session[:cart_id] = nil
    redirect_to cart_path, notice: "Sua sacola está vazia"
  end

  #
  # Only used by chaordic and wishlist
  #
  def add_variants
    @report  = CreditReportService.new(@user) unless @report
    cart = Cart.find_by_id(params[:cart_id]) || current_cart
    cart.add_variants params[:variant_numbers]
    @cart_calculator = CartProfit::CartCalculator.new(@cart)

    respond_to do |format|
      format.html { render :show }
      format.json { render json: {message: 'sucesso!'} }
    end
  end

  def update
    format_params
    
    @cart.update_attributes(params[:cart])
    if @cart.errors.any?
      @notice_message = @cart.errors[:coupon_code].first
      render :error
      return
    end

    @cart.reload
    @cart_calculator = CartProfit::CartCalculator.new(@cart)

    if @cart.coupon
      @coupon_value = -1 * (@cart.items.inject(0.0){|sum,i| sum+i.adjustment_value.to_f})
    end

    @freebie = Freebie.new(subtotal: @cart.sub_total, cart_id: @cart.id)
  end

  def i_want_freebie
    Freebie.save_selection_for(@cart.id, params[:i_want_freebie])
    render text: 'OK'
  end

  private

  def format_params 
    params[:cart].merge!({use_credits: false}) if params[:cart][:coupon_code].present?
  end

end
