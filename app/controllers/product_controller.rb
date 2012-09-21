# -*- encoding : utf-8 -*-
class ProductController < ApplicationController
  respond_to :html

  def show
    @facebook_app_id = FACEBOOK_CONFIG["app_id"]
    @url = request.protocol + request.host

    @product = if session[:product_view_mode] == "admin" || (current_admin && session[:product_view_mode].nil?)
      Product.find(params[:id])
    else
      Product.only_visible.find(params[:id])
    end
    @variants = @product.variants
    @gift = (params[:gift] == "true")
    @only_view = (params[:only_view] == "true")
    @shoe_size = params[:shoe_size].to_i
    respond_to :html, :js
  end
end

