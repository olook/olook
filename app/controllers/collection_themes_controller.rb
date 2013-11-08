# -*- encoding : utf-8 -*-
class CollectionThemesController < SearchController
  layout "lite_application"

  def index
    @featured_products = retrieve_featured_products
    @collection_theme_groups = CollectionThemeGroup.order(:position).includes(:collection_themes)
  end

  def show
    search_params = SeoUrl.parse(request.fullpath)
    Rails.logger.debug("New params: #{params.inspect}")
    @campaign_products = HighlightCampaign.campaign_products(params[:cmp])

    @search = SearchEngine.new(search_params).for_page(params[:page]).with_limit(48)
    params.merge!(search_params)
    @url_builder = SeoUrl.new(search_params, "collection_theme", @search)
    @collection_theme = CollectionTheme.where(slug: params[:collection_theme])
    @collection_theme_groups = CollectionThemeGroup.order(:position).includes(:collection_themes)
    @cache_key = "collections#{request.path}|#{@search.cache_key}#{@campaign_products.cache_key}"

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

    # TODO: Lógica duplicada no model payment onde usa o Product#featured_products
    def retrieve_featured_products
      products = Setting.collection_section_featured_products.split('#')
      products_models = Product.where(id: products.map { |p| p.split('|').last.to_i}).all
      products.map! do |pair|
        values = pair.split('|')
        product = products_models.find { |p| p.id == values[1].to_i }
        if product
          {
            label: values[0],
            product: product
          }
        else
          nil
        end
      end
      products.compact!
      products.select {|h| h[:product].inventory_without_hiting_the_database > 0}
    end

end
