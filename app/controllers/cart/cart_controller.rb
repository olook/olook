# -*- encoding : utf-8 -*-
class Cart::CartController < ApplicationController
  layout "site"

  respond_to :html, :js
  skip_before_filter :authenticate_user!, :only => :add_variants

  def show
    @google_path_pixel_information = "cart"
    @google_pixel_information = @cart
    @report  = CreditReportService.new(@user)
    @url = request.protocol + request.host
    @url += ":" + request.port.to_s if request.port != 80
    @chaordic_cart = ChaordicInfo.cart(@cart, current_user, cookies[:ceid])
    @suggested_product = find_suggested_product
    @cart_calculator = CartProfit::CartCalculator.new(@cart)
    @promo_over_coupon = false
    if @cart.coupon_id && Promotion.select_promotion_for(@cart)
      @promo_over_coupon = true
    end
    @freebie = Freebie.new(subtotal: @cart.sub_total, cart_id: @cart.id)
  end

  def destroy
    @cart.destroy
    session[:cart_id] = nil
    redirect_to cart_path, notice: "Sua sacola está vazia"
  end

  #
  # Only used by chaordic
  #
  def add_variants
    @report  = CreditReportService.new(@user) unless @report
    cart = Cart.find_by_id(params[:cart_id]) || current_cart
    cart.add_variants params[:variant_numbers]
    render :show
  end

  def update
    @cart.update_attributes(params[:cart])
    if @cart.errors.any?
      @notice_message = @cart.errors[:coupon_code].first
      render :error
      return
    end

    @cart.reload
    @cart_calculator = CartProfit::CartCalculator.new(@cart)

    #
    # Isto é feio, muito feio. Juro que volto aqui para refatorar
    #
    if @cart.coupon && @cart.coupon.promotion_action.is_a?(ValueAdjustment)
      @coupon_value = -1 * @cart.coupon.action_parameter.action_params[:param].to_f
    end

    @freebie = Freebie.new(subtotal: @cart.sub_total, cart_id: @cart.id)
  end

  def i_want_freebie
    Freebie.save_selection_for(@cart.id, params[:i_want_freebie])
    render text: 'OK'
  end

  private
    # TODO => Consider moving this logic to Product class
    def find_suggested_product
      suggested_products_with_inventory.shuffle.first
    end

    def suggested_products_with_inventory
      ids = Setting.recommended_products.split(",").map {|product_id| product_id.to_i}
      products = Product.find ids
      products.delete_if {|product| product.inventory < 1}
    end
end
