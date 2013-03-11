# -*- encoding : utf-8 -*-
class MomentsController < ApplicationController
  respond_to :html, :js

  before_filter :load_products_of_user_size, only: [:show]
  before_filter :load_chaordic_user, only: [:show, :index]
  before_filter :filter_products_by_category, :unless => lambda{ params[:category_id].nil? }
  before_filter :add_featured_products, :unless => lambda{ params[:category_id].nil? }
  before_filter :load_catalog_products

  def load_chaordic_user
    @chaordic_user = ChaordicInfo.user current_user
  end

  def index
    render :show, id: @moment.id
  end

  def show
    @pixel_information = params[:category_id]
    if CollectionTheme.active.first.try(:catalog).try(:products).nil?
      flash[:notice] = "A coleção não possui produtos disponíveis"
      redirect_to member_showroom_path
    else
      respond_with @catalog_products
    end
  end

  def update
    respond_with @catalog_products
  end

  def clothes
    render :show
  end

  #
  # This method exists for the only purpose to achieve the
  # "hover" effect on the 'Oculos' link in the menu bar
  #
  def glasses
    @glasses = "Oculos"
    render :show
  end

  private

  def load_products_of_user_size
    # To show just the shoes of the user size at the
    # first time that the liquidations page is rendered
    params[:shoe_sizes] = [current_user.shoes_size.to_s] if current_user && current_user.shoes_size
  end

  def load_catalog_products
    @collection_themes = CollectionTheme.active.order(:position)
    @collection_theme = params[:id] ? CollectionTheme.find_by_id(params[:id]) : @collection_themes.last

    if @collection_theme
      @catalog_products = CatalogSearchService.new(params.merge({id: @collection_theme.catalog.id})).search_products
      @products_id = @catalog_products.map{|item| item.product_id }.compact
      # params[:id] is into array for pixel iterator
      @categories_id = params[:id] ? [params[:id]] : @collection_themes.map(&:id).compact.uniq
    else
      redirect_to root_path
      flash[:notice] = "No momento não existe nenhuma ocasião cadastrada."
    end
  end

  def add_featured_products
    @featured_products = Product.featured_products(@category_id).first(3)
  end

  def filter_products_by_category
    if (params[:category_id].nil? || params[:category_id] == "")
      params.delete :category_id
    else
      @category_id = params[:category_id].to_i
    end
    params.delete (:shoe_sizes) if @category_id != Category::SHOE
  end


end
