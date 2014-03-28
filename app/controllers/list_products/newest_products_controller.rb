# -*- encoding : utf-8 -*-
class ListProducts::NewestProductsController < ListProductsController
  @url_prefix = '/novidades'
  PRODUCTS_SIZE = 42

  def index
    @path_positions =  '/novidades/-:category::brand::subcategory:-/_:care::color::size::heel:-'
    visibility = "#{Product::PRODUCT_VISIBILITY[:site]}-#{Product::PRODUCT_VISIBILITY[:all]}"
    search_params = SeoUrl.parse(path: request.fullpath, path_positions: @path_positions).merge({visibility: visibility})

    default_params(search_params, "novidades")

    @search.sort = 'age'
    @search.with_limit(PRODUCTS_SIZE)
    @search.for_page(1)
    @hide_pagination = true
  end

  private
  def header
    @header ||= Header.for_url(request.path).first
    @header ||= Header.for_url(self.class.url_prefix).first
  end

end
