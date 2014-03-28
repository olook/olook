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

  def prefix_for_page_title
    url_prefix.gsub("/","").capitalize
  end

  def default_params(search_params, site_section)
    page_size = params[:page_size] || DEFAULT_PAGE_SIZE
    search_params[:skip_beachwear_on_clothes] = true
    @url_builder = SeoUrl.new(path: request.fullpath, search: @search, path_positions: @path_positions)
    @search = SearchEngine.new(@url_builder.parse_params).for_page(params[:page]).with_limit(page_size)
    @search.for_admin if current_admin
    @url_builder.set_search @search
    @campaign_products = HighlightCampaign.find_campaign(params[:cmp])

    @chaordic_user = ChaordicInfo.user(current_user, cookies[:ceid])
    @category = @search.expressions[:category].try(:first)
    params[:category] = @search.expressions[:category].try(:first)
    @cache_key = configure_cache(@search)
  end

  def configure_cache(search)
    cache_key = "#{url_prefix}#{request.path}|#{@search.cache_key}#{@campaign_products.cache_key if @campaign_products}"
    expire_fragment(cache_key) if params[:force_cache].to_i == 1
    cache_key
  end


  def title_text
    return "#{prefix_for_page_title} | Sapatos Femininos | Olook" if @category && @category == 'sapato'
    return "#{prefix_for_page_title} | #{@category}s Femininas | Olook" if @category && @category != 'sapato'
    "#{prefix_for_page_title} | Roupas Femininas e Sapatos Femininos | Olook"
  end

  def canonical_link
    return "http://#{request.host_with_port}/#{prefix_for_page_title}/#{@category}" if @category
    "http://#{request.host_with_port}/#{prefix_for_page_title}"
  end

  def meta_description
    Seo::DescriptionManager.new(description_key: prefix_for_page_title).choose
  end

end
