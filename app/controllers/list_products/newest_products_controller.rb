# -*- encoding : utf-8 -*-
class ListProducts::NewestProductsController < ListProductsController
  @url_prefix = '/novidades'
  PRODUCTS_SIZE = 32

  def index
    @path_positions =  '/novidades/-:category::brand::subcategory:-/-:care::color::size::heel:_'
    @visibility = "#{Product::PRODUCT_VISIBILITY[:site]}-#{Product::PRODUCT_VISIBILITY[:all]}"
    default_params
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
