# -*- encoding : utf-8 -*-
class MomentsController < ApplicationController
  layout "moment"
  respond_to :html, :js

  before_filter :load_products_of_user_size, only: [:show]
  before_filter :load_catalog_products

  def index
    render :show, id: @moment.id
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

  def load_products_of_user_size
    # To show just the shoes of the user size at the 
    # first time that the liquidations page is rendered
    params[:shoe_sizes] = current_user.user_info.shoes_size.to_s if current_user && current_user.user_info
  end

  def load_catalog_products
    @moments = Moment.active.order(:position)
    @moment = params[:id] ? Moment.find_by_id(params[:id]) : @moments.last

    if @moment
      @catalog_products = CatalogSearchService.new(params.merge({id: @moment.catalog.id})).search_products
    else
      redirect_to root_path
      flash[:notice] = "No momento não existe nenhuma ocasião cadastrada."
    end
  end

end
