# -*- encoding : utf-8 -*-
class CollectionThemesController < SearchController
  layout "lite_application"

  def index
    @collection_theme_groups = CollectionThemeGroup.order(:position).includes(:collection_themes)
  end

  def show
    @url_builder = SeoUrl.new(path: request.fullpath, path_positions: '/colecoes/:collection_theme:/-:category::subcategory::brand:-/-:care::color::size::heel:_')
    Rails.logger.debug("New params: #{params.inspect}")
    search_params = @url_builder.parse_params
    @campaign = HighlightCampaign.find_campaign(params[:cmp])
    @search = SearchEngine.new(search_params, skip_beachwear_on_clothes: true).for_page(params[:page]).with_limit(48)
    @url_builder.set_search @search
    @color = search_params["color"]
    @size = search_params["size"]
    @brand_name = search_params["brand"]
    @collection_theme = CollectionTheme.where(slug: params[:collection_theme])
    @collection_theme_groups = CollectionThemeGroup.order(:position).includes(:collection_themes)
    @cache_key = "collections#{request.path}|#{@search.cache_key}#{@campaign.cache_key}"
    redirect_to collection_theme_not_found_path if Rails.cache.fetch("#{@cache_key}count", expire: 90.minutes) { @search.products.size }.to_i == 0
    expire_fragment(@cache_key) if params[:force_cache].to_i == 1
  end

  def not_found
    @url_builder = SeoUrl.new(path: request.fullpath, path_positions: '/colecoes/:collection_theme:/-:category::subcategory::brand:-/-:care::color::size::heel:_')
    @search = SearchEngine.new(@url_builder.parse_params).for_page(params[:page]).with_limit(48) 
    @url_builder.set_search @search
    @collection_theme = CollectionTheme.where(slug: params[:collection_theme])
    @collection_theme_groups = CollectionThemeGroup.order(:position).includes(:collection_themes)
  end

  private

    def canonical_link
      collection_theme = Array(@collection_theme).first
      if collection_theme 
        "http://#{request.host_with_port}/#{collection_theme.slug}"
      end
    end
end
