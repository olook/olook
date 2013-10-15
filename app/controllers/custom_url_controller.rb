class CustomUrlController < ApplicationController
  layout "lite_application"
  DEFAULT_PAGE_SIZE = 48
  def show
    @custom_url = CatalogHeader::CatalogBase.for_url(request.path).first
    if @custom_url
      @custom_url_products = SearchEngine.new(product_id: @custom_url.product_list)
      page_size = params[:page_size] || DEFAULT_PAGE_SIZE
      search_params = SeoUrl.parse(@custom_url.organic_url)
      @search = SearchEngine.new(search_params, true).for_page(params[:page]).with_limit(page_size)
    else
      redirect_to root_url
    end
  end
end
