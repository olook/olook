# -*- encoding : utf-8 -*-
class ListProducts::OlookletController < ListProductsController
  @url_prefix = '/olooklet'

  def index
    @path_positions = '/olooklet/-:category::brand::subcategory:-/-:care::color::size::heel:_'
    @visibility = params[:visibility] || "#{Product::PRODUCT_VISIBILITY[:olooklet]}-#{Product::PRODUCT_VISIBILITY[:all]}"
    default_params
  end

  def not_found
    @path_positions = '/olooklet/-:category::brand::subcategory:-/-:care::color::size::heel:_'
    default_params
  end

  private

  def header
    @header ||= Header.for_url(request.path).first
    @header ||= Header.for_url(self.class.url_prefix).first
  end
end
