class NewestProductsController < ApplicationController
  DEFAULT_PAGE_SIZE = 48
  helper_method :header

  def index
    page_size = params[:page_size] || DEFAULT_PAGE_SIZE
    request_path = request.fullpath
    search_params = SeoUrl.parse(request_path)
    @search = SearchEngine.new(search_params, true).for_page(params[:page]).with_limit(page_size)
    @search.sort = 'age'
    @url_builder = SeoUrl.new(search_params, 'novidades', @search)
    @url_builder.set_link_builder {|_param| newest_path(_param)}
    render 'olooklet/index'
  end

  private
  def header
    @header ||= CatalogHeader::CatalogBase.for_url("/#{params[:lbl]}").first
  end
end
