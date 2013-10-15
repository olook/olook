class CustomUrlController < ApplicationController
  layout "lite_application"
  DEFAULT_PAGE_SIZE = 48
  def show
    @custom_url = CatalogHeader::CatalogBase.for_url(request.path).first
    if @custom_url
      @custom_search = SearchEngine.new(product_id: @custom_url.product_list)
      page_size = params[:page_size] || DEFAULT_PAGE_SIZE
      search_params = SeoUrl.parse(@custom_url.organic_url)
      @search = SearchEngine.new(search_params, true).for_page(params[:page]).with_limit(page_size)
      @url_builder = SeoUrl.new(search_params, "category", @search)
      /\/?(?<category>roupa|bolsa|sapato|acessorio)[\/$]/ =~ @custom_url.organic_url.to_s
      @category = category
    else
      redirect_to root_url
    end
  end

  private

    def title_text 
      Seo::SeoManager.new(request.path, model: @custom_url).select_meta_tag
    end

    def canonical_link
      "#{request.protocol}#{request.host_with_port}#{@custom_url.url}"
    end
end
