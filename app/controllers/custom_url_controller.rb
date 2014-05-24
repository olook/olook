class CustomUrlController < ApplicationController
  layout "lite_application"
  DEFAULT_PAGE_SIZE = 32
  helper_method :check_organic_url_section

  def show
    @custom_url = Header.for_url(request.path).first
    if @custom_url
      product_list = @custom_url.product_list.to_s.split(/\D/).select{|w|w.present?}.compact
      @custom_search = SearchEngine.new(product_id: product_list)
      page_size = params[:page_size] || DEFAULT_PAGE_SIZE
      @url_builder = SeoUrl.new(path: @custom_url.organic_url, path_positions: path_positions_by_section)
      search_params = @url_builder.parse_params
      @search = SearchEngine.new(search_params, is_smart: true).for_page(params[:page]).with_limit(page_size)
      @url_builder.set_search(@search)
      @category = @search.current_filters['category'].try(:first)
      @collection_theme_groups = CollectionThemeGroup.order(:position).includes(:collection_themes)
      @cache_key = "custom_url#{request.path}|#{@search.cache_key}#{@custom_url.cache_key}"
    else
      redirect_to root_url
    end
  end

  private

  def path_positions_by_section
    case @custom_url.organic_url
    when /^\/colecoes/i
      '/colecoes/:collection_theme:/-:category::brand::subcategory:-/-:care::color::size::heel:_'
    when /^\/marcas/i
      '/marcas/:brand:/-:category::subcategory:-/-:care::color::size::heel:_'
    when /^\/(olooklet|selecoes|novidades)/i
      "/#{$1}/-:category::brand::subcategory:-/-:care::color::size::heel:_"
    when /^\/busca/i
      '/busca'
    else
      '/:category:/-:brand::subcategory:-/-:care::color::size::heel:_'
    end
  end

  def check_organic_url_section(hash)
    case
    when /^\/?colecoes/i =~ @custom_url.organic_url
      if hash[:collection].respond_to?(:call)
        hash[:collection].call
      else
        hash[:collection]
      end
    when /^\/?marcas/i =~ @custom_url.organic_url
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

  def canonical_link
    "#{request.protocol}#{request.host_with_port}#{@custom_url.url}"
  end
end
