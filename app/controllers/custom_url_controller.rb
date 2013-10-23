class CustomUrlController < ApplicationController
  layout "lite_application"
  DEFAULT_PAGE_SIZE = 48
  helper_method :check_organic_url_section

  def show
    @custom_url = CatalogHeader::CatalogBase.for_url(request.path).first
    if @custom_url
      @custom_search = SearchEngine.new(product_id: @custom_url.product_list.to_s.split(/\D/).join('-'))
      page_size = params[:page_size] || DEFAULT_PAGE_SIZE
      search_params = SeoUrl.parse(@custom_url.organic_url)
      @search = SearchEngine.new(search_params, true).for_page(params[:page]).with_limit(page_size)
      @url_builder = check_organic_url_section(
        catalog: SeoUrl.new(search_params, "category", @search),
        brand: SeoUrl.new(search_params, "brand", @search),
        collection: SeoUrl.new(search_params, "collection_theme", @search)
      )
      @category = @search.current_filters['category'].first
      @collection_theme_groups = CollectionThemeGroup.order(:position).includes(:collection_themes)
    else
      redirect_to root_url
    end
  end

  private

  def check_organic_url_section(hash)
    case
    when /^\/?colecoes/ =~ @custom_url.organic_url
      if hash[:collection].respond_to?(:call)
        hash[:collection].call
      else
        hash[:collection]
      end
    when /^\/?marcas/ =~ @custom_url.organic_url
      if hash[:brand].respond_to?(:call)
        hash[:brand].call
      else
        hash[:brand]
      end
    else
      if hash[:catalog].respond_to?(:call)
        hash[:catalog].call
      else
        hash[:catalog]
      end
    end
  end

    def title_text
      Seo::SeoManager.new(request.path, model: @custom_url).select_meta_tag
    end

    def canonical_link
      "#{request.protocol}#{request.host_with_port}#{@custom_url.url}"
    end
end
