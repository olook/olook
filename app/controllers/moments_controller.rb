# -*- encoding : utf-8 -*-
class MomentsController < ApplicationController
  layout "moment"
  respond_to :html, :js

  before_filter :load_order, only: [:show]
  before_filter :load_catalog_products

  def index
    respond_with @catalog_products
  end

  def show
    if current_moment.catalog.products.nil?
      flash[:notice] = "O momento não possui produtos"
      redirect_to member_showroom_path 
    else
      respond_with @catalog_products
    end
  end

  def update
    respond_with @catalog_products
  end

  private

  def load_catalog_products
    @moments = Moment.active.all
    @moment = params[:id] ? Moment.find_by_id(params[:id]) : @moments.first

    @catalog_products = CatalogSearchService.new(params.merge({id: @moment.id})).search_products
    # @catalog_products_products = CatalogSearchService.remove_color_variations(@catalog_products.map{ |cp| Product.find(cp.product_id) })
  end

end
