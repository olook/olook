# -*- encoding : utf-8 -*-
class Cart::CartController < ApplicationController
  layout "site"

  respond_to :html, :js

  def show
    @google_path_pixel_information = "Carrinho"
    @report  = CreditReportService.new(@user)
    @url = request.protocol + request.host
    @url += ":" + request.port.to_s if request.port != 80
    @lookbooks = Lookbook.active.all
    @suggested_product = find_suggested_product
    @promotion_free_item = Promotion.find_by_strategy("free_item_strategy")
  end

  def destroy
    @cart.destroy
    session[:cart_id] = nil
    redirect_to cart_path, notice: "Sua sacola está vazia"
  end

  def update
    unless @cart.update_attributes(params[:cart])
      notice_message = @cart.errors.messages.values.flatten.first
      render :error, :locals => { :notice => notice_message }
    end
  end

  def find_suggested_product
    ids = Setting.recommended_products.split(",").map {|product_id| product_id.to_i} 
    products = Product.find ids
    products.shuffle.first if products
  end
end
