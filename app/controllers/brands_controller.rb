class BrandsController < ApplicationController
  layout "lite_application"

  before_filter :set_brand, only: [ :show, :not_found ]
  before_filter :set_url_builder, only: [ :index, :show, :not_found ]
  before_filter :load_cmp, only: :show
  before_filter :load_chaordic_user, only: :show

  def index
    set_search
    @brands = BrandsFormat.new.retrieve_brands
  end

  def show
    if @search_params['category'] == 'roupa'
      @url_builder.set_params('category', 'roupa')
    end
    set_search
    redirect_to brand_not_found_path if @search.products.size == 0

    @color = @search_params["color"]
    @size = @search_params["size"]
    expire_fragment(@search.cache_key) if params[:force_cache].to_i == 1
  end

  def not_found
    set_search
  end

  private

  def set_search
    @search = SearchEngine.new(@search_params, skip_beachwear_on_clothes: true).for_page(params[:page]).with_limit(48)
    @search.for_admin if current_admin
    @url_builder.set_search @search
  end

  def set_brand
    @brand = Brand.where(name: params[:brand].to_s.split("-").map{|brand| ActiveSupport::Inflector.transliterate(brand).downcase.titleize}.join(' '))
  end

  def set_url_builder
    @url_builder = SeoUrl.new(path: request.fullpath, path_positions: '/marcas/:brand:/-:category::subcategory:-/-:care::color::size::heel:_')
    @search_params = @url_builder.parse_params
  end

  def canonical_link
    brand = Array(@brand).first
    if brand
      "http://#{request.host_with_port}/#{brand.name.downcase}"
    end
  end
end
