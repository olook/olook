# -*- encoding : utf-8 -*-
class ProductController < ApplicationController
  respond_to :html
<<<<<<< HEAD
  before_filter :authenticate_user!, except: [:show, :create_offline_session, :autocomplete_information]
  before_filter :load_user, except: [:autocomplete_information]
  before_filter :check_product_variant, only: [:add_to_cart]
  before_filter :load_order, except: [:autocomplete_information]
=======
>>>>>>> master

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

