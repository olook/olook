# -*- encoding : utf-8 -*-
class ProductController < ApplicationController
  respond_to :html
  before_filter :authenticate_user!, :except => [:show, :create_offline_session]
  before_filter :load_user
  before_filter :check_early_access
  before_filter :check_product_variant, :only => [:add_to_cart]
  before_filter :load_order

  def show
    @product = Product.only_visible.find(params[:id])
    @variants = @product.variants
  end

  def create_offline_session
    @session = (session[:offline_variant] = params[:variant])
    respond_to do |format|
      format.json { render :json => @session }
    end
  end
end

