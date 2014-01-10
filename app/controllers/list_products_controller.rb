class ListProductsController < ApplicationController
  layout "lite_application"
  helper_method :header, :url_prefix
  DEFAULT_PAGE_SIZE = 48
  class << self
    attr_reader :url_prefix
  end

  protected

  def url_prefix
    self.class.url_prefix
  end

  def default_params(search_params, site_section)
    page_size = params[:page_size] || DEFAULT_PAGE_SIZE
    search_params[:skip_beachwear_on_clothes] = true
    @search = SearchEngineWithDynamicFilters.new(search_params, true).for_page(params[:page]).with_limit(page_size)
    @search.for_admin if current_admin

    @url_builder = SeoUrl.new(search_params, site_section, @search)
    @antibounce_box = AntibounceBox.new(params) if AntibounceBox.need_antibounce_box?(@search, @search.expressions["brand"].map{|b| b.downcase}, params)

    @chaordic_user = ChaordicInfo.user(current_user, cookies[:ceid])
    @pixel_information = @category = params[:category]
    @category = @search.expressions[:category].first
    params[:category] = @search.expressions[:category].first
    @cache_key = configure_cache(@search)
  end

  def configure_cache(search)
    cache_key = "#{url_prefix}#{request.path}|#{@search.cache_key}#{@campaign_products.cache_key if @campaign_products}"
    expire_fragment(cache_key) if params[:force_cache].to_i == 1
    cache_key
  end

end
