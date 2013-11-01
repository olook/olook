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

    @promo_over_coupon = false
    if @cart && @cart.coupon && !@cart.items.empty?
      if @cart.coupon.is_more_advantageous_than_any_promotion? @cart
        @promo_over_coupon = true if @cart.items.any? { |i| i.liquidation? }
      else
        @cart.remove_coupon!
        @promo_over_coupon = true
      end
    end
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
    if Promotion.select_promotion_for(@cart)
      params[:cart].delete(:coupon_code)
      render :error, :locals => { :notice => "Os descontos não são acumulativos, então escolhemos o desconto mais vantajoso para você." }
    end
    @cart.update_attributes(params[:cart])
    if @cart.errors.any?
      notice_message = @cart.errors.messages.values.flatten.first
      render :error, :locals => { :notice => notice_message }
    end
    @cart.reload
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
