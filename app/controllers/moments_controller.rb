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
    if current_moment.resume.nil?
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
    @moment = Moment.active.first
    @catalog_products = CatalogSearchService.new(params).search_products
  end

end
