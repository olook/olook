# -*- encoding : utf-8 -*-
class ProductController < ApplicationController
  respond_to :html

  def show
    @facebook_app_id = FACEBOOK_CONFIG["app_id"]
    @url = request.protocol + request.host
    @product = Product.only_visible.find(params[:id])
    @variants = @product.variants
    @gift = (params[:gift] == "true")
    @only_view = (params[:only_view] == "true")
    @shoe_size = params[:shoe_size].to_i
    respond_to :html, :js
  end
end
