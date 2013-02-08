# -*- encoding : utf-8 -*-
class Cart::CartController < ApplicationController
  layout "site"

  respond_to :html, :js

  def show
    @google_path_pixel_information = "Carrinho"
    @google_pixel_information = @cart
    @report  = CreditReportService.new(@user)
    @url = request.protocol + request.host
    @url += ":" + request.port.to_s if request.port != 80
    @lookbooks = Lookbook.active.all
    @suggested_product = find_suggested_product
    @chaordic_cart = ChaordicInfo.cart @cart, current_user
  end

  def destroy
    @cart.destroy
    session[:cart_id] = nil
    redirect_to cart_path, notice: "Sua sacola está vazia"
  end

  def update
    coupon = Coupon.find_by_code(params[:cart][:coupon_code])

    unless should_apply?(coupon, @cart)
      params[:cart].delete(:coupon_code)
      render :error, :locals => { :notice => "A promoção é mais vantajosa que o cupon" }
    end

    unless @cart.update_attributes(params[:cart])
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


    def should_apply?(coupon, cart)
      return true if coupon.nil?
      coupon.should_apply_to? cart
    end

end
