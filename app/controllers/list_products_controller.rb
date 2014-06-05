class ListProductsController < ApplicationController
  layout "lite_application"
  helper_method :header, :url_prefix
  DEFAULT_PAGE_SIZE = 32
  class << self
    attr_reader :url_prefix
  end

  def not_found
    @url_builder = SeoUrl.new(path: request.fullpath, path_positions: @path_positions)
    search_params = @url_builder.parse_params 
    @search = SearchEngine.new(search_params)
    @search.for_admin if current_admin
    @url_builder.set_search @search
  end

  protected

  def url_prefix
    self.class.url_prefix
  end

  def prefix_for_page_title
    url_prefix.gsub("/","").capitalize
  end

  def add_search_result(search_params, params)
    search_params[:limit] = params[:page_size] || DEFAULT_PAGE_SIZE
    search_params[:page] = params[:page]
    search_params[:admin] = !!current_admin
    search = SearchEngine.new(search_params, is_smart: true)
    search
  end

  def default_params
    @url_builder = SeoUrl.new(path: request.fullpath, path_positions: @path_positions)

    search_params = @url_builder.parse_params
    search_params[:skip_beachwear_on_clothes] = true
    search_params[:visibility] = @visibility
    @search = add_search_result(search_params, params)
    @search.for_admin if current_admin
    @url_builder.set_search @search
    @color = search_params["color"]
    @size = search_params["size"]
    @brand_name = search_params["brand"]
    @campaign_products = HighlightCampaign.find_campaign(params[:cmp])
    @category = params[:category] = @search.filter_value(:category).try(:first)
    @url_builder.set_params(:category, @category)
    @cache_key = configure_cache(@search)
  end

  def configure_cache(search)
    cache_key = "#{url_prefix}#{request.path}|#{@search.cache_key}#{@campaign_products.cache_key if @campaign_products}"
    expire_fragment(cache_key) if params[:force_cache].to_i == 1
    cache_key
  end

  def canonical_link
    return "http://#{request.host_with_port}/#{prefix_for_page_title}/#{@category}" if @category
    "http://#{request.host_with_port}/#{prefix_for_page_title}"
  end

end
