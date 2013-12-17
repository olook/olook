class NewestProductsController < ApplicationController
  DEFAULT_PAGE_SIZE = 48

  def index
    page_size = params[:page_size] || DEFAULT_PAGE_SIZE
    request_path = request.fullpath
    search_params = SeoUrl.parse(request_path)
    @search = SearchEngine.new(search_params, true).for_page(params[:page]).with_limit(page_size)
    @url_builder = SeoUrl.new(search_params, 'olooklet', @search)
    @filters_presenter = FiltersPresenter.new('olooklet')
  end
end
