# -*- encoding : utf-8 -*-
class CollectionThemesController < SearchController
  layout "lite_application"

  def index
    @collection_theme_groups = CollectionThemeGroup.order(:position).includes(:collection_themes)
  end

  def show
    search_params = SeoUrl.parse(request.fullpath)
    Rails.logger.debug("New params: #{params.inspect}")

    #FIXME remove this line ASAP
    params[:cmp] = "trabalho-27112013 " if params[:collection_theme] == "executivo"

    @campaign = HighlightCampaign.find_campaign(params[:cmp])
    @search = SearchEngine.new(search_params, true).for_page(params[:page]).with_limit(48)
    params.merge!(search_params)
    @url_builder = SeoUrl.new(search_params, "collection_theme", @search)
    @collection_theme = CollectionTheme.where(slug: params[:collection_theme])
    @collection_theme_groups = CollectionThemeGroup.order(:position).includes(:collection_themes)
    @cache_key = "collections#{request.path}|#{@search.cache_key}#{@campaign.cache_key}"

  end

  private

    def title_text 
      Seo::SeoManager.new(request.path, model: @collection_theme.try(:first), search: @search).select_meta_tag
    end

    def canonical_link
      collection_theme = Array(@collection_theme).first
      if collection_theme 
        "#{request.protocol}#{request.host_with_port}/#{collection_theme.slug}"
      end
    end
end
