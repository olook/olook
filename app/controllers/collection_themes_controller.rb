# -*- encoding : utf-8 -*-
class CollectionThemesController < ApplicationController
  respond_to :html, :js

  before_filter :load_products_of_user_size, only: [:show]
  before_filter :filter_products_by_category, :unless => lambda{ params[:category_id].nil? }
  before_filter :load_catalog_products

  # Toda a lógica dessa página deve ser refeita para dinamizar os dados dela
  def index
    @featured_products = retrieve_featured_products
  end

  def show
    @chaordic_user = ChaordicInfo.user current_user
  end

  private

    def load_products_of_user_size
      # To show just the shoes of the user size at the
      # first time that the liquidations page is rendered
      params[:shoe_sizes] = [current_user.shoes_size.to_s] if current_user && current_user.shoes_size
    end

    def filter_products_by_category
      if (params[:category_id].nil? || params[:category_id] == "")
        params.delete :category_id
      else
        @category_id = params[:category_id].to_i
      end
      params.delete (:shoe_sizes) if @category_id != Category::SHOE
    end

    def load_catalog_products
      @collection_theme_groups = CollectionThemeGroup.includes(:collection_themes).order(:position).all
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

    # TODO: Lógica duplicada no model payment onde usa o Product#featured_products
    def retrieve_featured_products
      products = Setting.collection_section_featured_products.split('#').map do |pair|
        values = pair.split('|')
        product = Product.find(values[1].to_i)
        {
          label: values[0],
          product: product
        }
      end
      products.select {|h| h[:product].inventory_without_hiting_the_database > 0}
    end


end
