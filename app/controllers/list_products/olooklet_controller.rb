# -*- encoding : utf-8 -*-
class ListProducts::OlookletController < ListProductsController
  @url_prefix = '/olooklet'

  def index
    @path_positions = '/olooklet/-:category::brand::subcategory:-/-:care::color::size::heel:_'
    @visibility = params[:visibility] || [Product::PRODUCT_VISIBILITY[:olooklet],Product::PRODUCT_VISIBILITY[:all]]
    params[:por] ||= "novidade"
    default_params
    redirect_to olooklet_not_found_path if Rails.cache.fetch("#{@cache_key}count", expire: 90.minutes) { @search.products.size }.to_i == 0
    expire_fragment(@cache_key) if params[:force_cache].to_i == 1
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
