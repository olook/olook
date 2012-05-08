# -*- encoding : utf-8 -*-
class CatalogsController < ApplicationController
  layout "liquidation"
  respond_to :html, :js

  before_filter :verify_if_active, :only => [:show]
  before_filter :load_order, :only => [:show]
  before_filter :load_liquidation_products

  def show
    @teaser_banner = current_liquidation.teaser_banner_url if current_liquidation
    if current_liquidation.resume.nil?
      flash[:notice] = "A liquidação não possui produtos"
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
    @catalog = Catalog.find(params[:id])
    @catalog_products = CatalogSearchService.new(params).search_products
  end

  def verify_if_active
    if LiquidationService.active.try(:id) != params[:id].to_i
      flash[:notice] = "O catalogo não está ativa"
      redirect_to member_showroom_path
    end
  end
end
