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
    @search = SearchEngine.new(search_params).for_page(params[:page]).with_limit(48)
    @url_builder.set_search @search
    @color = search_params["color"]
    @size = search_params["size"]
    @collection_theme = CollectionTheme.where(slug: params[:collection_theme])
    @collection_theme_groups = CollectionThemeGroup.order(:position).includes(:collection_themes)
    @cache_key = "collections#{request.path}|#{@search.cache_key}#{@campaign.cache_key}"

  end

  private

    def canonical_link
      collection_theme = Array(@collection_theme).first
      if collection_theme 
        "http://#{request.host_with_port}/#{collection_theme.slug}"
      end
    end
end
