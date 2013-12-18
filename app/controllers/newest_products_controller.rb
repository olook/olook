class NewestProductsController < ApplicationController
  DEFAULT_PAGE_SIZE = 48

  def index
    page_size = params[:page_size] || DEFAULT_PAGE_SIZE
    request_path = request.fullpath
    search_params = SeoUrl.parse(request_path)
    @search = SearchEngine.new(search_params, true).for_page(params[:page]).with_limit(page_size)
    @search.sort = 'age'
    @url_builder = SeoUrl.new(search_params, 'novidades', @search)
    @url_builder.set_link_builder {|_param| newest_path(_param)}
  end
end
