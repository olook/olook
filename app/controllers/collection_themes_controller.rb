# -*- encoding : utf-8 -*-

class CollectionThemesController < ApplicationController
  respond_to :html, :js

  before_filter :load_catalog_products

  def index
    @featured_products = retrieve_featured_products
  end

  def show
    @chaordic_user = ChaordicInfo.user current_user
  end

  def update
    respond_with @catalog_products
  end

  private
    def load_catalog_products
      params.delete(:category_id) unless params[:category_id]
      # @collection_theme_groups = CollectionThemeGroup.all
      @collection_themes = CollectionTheme.active.order(:position)
      @collection_theme = params[:slug] ? CollectionTheme.find_by_slug_or_id(params[:slug]) : @collection_themes.last
      if @collection_theme
        @catalog_products = CatalogSearchService.new(params.merge({id: @collection_theme.catalog.id})).search_products
        @products_id = @catalog_products.map{|item| item.product_id }.compact
        # params[:id] is into array for pixel iterator
        @categories_id = params[:id] ? [params[:id]] : @collection_themes.map(&:id).compact.uniq
      else
        redirect_to root_path
        flash[:notice] = "No momento não existe nenhuma coleção cadastrada."
      end
    end

    def retrieve_featured_products
      Setting.collection_section_featured_products.split('#').map do |pair|
        values = pair.split('|')
        product = Product.find(values[1].to_i)
        {
          label: values[0],
          product: product
        }
      end
    end


end
