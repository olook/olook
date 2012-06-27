# -*- encoding : utf-8 -*-
class ProductController < ApplicationController
  respond_to :html
  before_filter :authenticate_user!, except: [:show, :create_offline_session, :autocomplete_product]
  before_filter :load_user, except: [:autocomplete_product]
  before_filter :check_product_variant, only: [:add_to_cart]
  before_filter :load_order, except: [:autocomplete_product]

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

  def create_offline_session
    @offline_variant_session = (session[:offline_variant] = params[:variant])
    @offline_first_access_session = session[:offline_first_access] = true
    respond_to do |format|
      format.json { render :json => @offline_variant_session }
    end
  end

  def autocomplete_information
    if params[:q] =~ /\A[A-Za-z]+/
      @products = Product.where "name like ?", "%#{params[:q]}%"
    elsif params[:q] =~ /\A[0-9]+/
      @products = Product.where "model_number like ?", "%#{params[:q]}%"
    else
      @products = []
    end

    @products
  end
end

