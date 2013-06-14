# -*- encoding : utf-8 -*-
class CatalogsController < ApplicationController
  layout "lite_application"
  respond_to :html, :js
  before_filter :load_catalog_products

  def show
    #category_id = Category.with_name(params[:category_name])
    @colors = Detail.colors(params[:category_id])
    @subcategories = Detail.subcategories(params[:category_id])
    @pixel_information = params[:category_id]
    if CollectionTheme.active.first.try(:catalog).try(:products).nil?
      flash[:notice] = "A coleção não possui produtos disponíveis"
      redirect_to member_showroom_path
    else
      respond_with @catalog_products
    end
  end

  def load_catalog_products
    params[:brands] = params[:brands].values if params[:brands].is_a?(Hash)
    @collection_themes = CollectionTheme.active.order(:position)
    @collection_theme = params[:id] ? CollectionTheme.find_by_id(params[:id]) : @collection_themes.last

    if @collection_theme
      params[:news] = session[:c] if session[:c]
      if current_admin
        params[:admin] = true
      end
      @catalog_products = CatalogSearchService.new(params.merge({id: @collection_theme.catalog.id})).search_products
      @products_id = @catalog_products.first(3).map{|item| item.product_id }.compact
      # params[:id] is into array for pixel iterator
      @categories_id = params[:id] ? [params[:id]] : @collection_themes.map(&:id).compact.uniq
    else
      redirect_to root_path
      flash[:notice] = "No momento não existe nenhuma ocasião cadastrada."
    end
  end

end
